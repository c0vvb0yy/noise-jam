extends Node2D

@onready
var label := $RichTextLabel

func entered(body_part : Sprite2D, part_name: String):
	label.text = part_name
	#body_part.modulate = Color.RED
	pass

func exited(body_part: Sprite2D):
	label.text = ""
	#body_part.modulate = Color.WHITE
	pass

func _on_arm_mouse_entered():
	entered($Arm, "An arm to hold")
	pass # Replace with function body.


func _on_eye_mouse_entered():
	entered($eye, "Eye for an Eye")
	pass # Replace with function body.


func _on_mouth_mouse_entered():
	entered($mouth, "Mouth to kiss")
	pass # Replace with function body.


func _on_hole_mouse_entered():
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
