extends Node2D

@onready
var label := $RichTextLabel

enum state {Eye, Arm, Jaw, Hole}
var current_state: state = state.Eye


func entered(body_part : Sprite2D, part_name: String):
	label.text = str("[skew h=45000 v =1][i]",part_name)
	#body_part.modulate = Color.RED
	pass

func set_up(new_state: state):
	current_state = new_state
	if current_state == state.Eye:
		$eye.active = true
		$Arm/Area2D/CollisionShape2D.disabled = true
		$mouth/Area2D/CollisionShape2D.disabled = true
		$hole.scale = Vector2(2, 2)
	if current_state == state.Arm:
		$Arm/Area2D/CollisionShape2D.disabled = false
		$eye.visible = false
		$Arm.active = true
		$hole.scale = Vector2(6.4, 6.4)
	if current_state == state.Jaw:
		$mouth/Area2D/CollisionShape2D.disabled = false
		$Arm.visible = false
		$mouth.active = true
		$hole.scale = Vector2(14.6, 14.6)
	if current_state == state.Hole:
		$hole/Area2D/CollisionShape2D.disabled = false
		$mouth.visible = false
		$hole.active = true
		$hole.scale = Vector2(18, 18)
		$Sun.visible = true

func exited(body_part: Sprite2D):
	label.text = ""
	#body_part.modulate = Color.WHITE
	pass

func _on_arm_mouse_entered():
	if current_state != state.Arm:
		return
	entered($Arm, "An arm to hold")
	pass # Replace with function body.


func _on_eye_mouse_entered():
	if current_state != state.Eye:
		return
	entered($eye, "Eye for an Eye")
	pass # Replace with function body.


func _on_mouth_mouse_entered():
	if current_state != state.Jaw:
		return
	entered($mouth, "Mouth to kiss")
	pass # Replace with function body.


func _on_hole_mouse_entered():
	if current_state != state.Hole:
		return
	entered($hole, "The hole-shaped Hole")
	pass # Replace with function body.


func _on_hole_mouse_exited():
	exited($hole)
	pass # Replace with function body.


func _on_mouth_mouse_exited():
	exited($mouth)
	pass # Replace with function body.


func _on_eye_mouse_exited():
	exited($eye)
	pass # Replace with function body.


func _on_arm_mouse_exited():
	exited($Arm)
	pass # Replace with function body.
