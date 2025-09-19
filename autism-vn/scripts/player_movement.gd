extends CharacterBody2D

const tile_size := Vector2(75, 75)
var sprite_pos_tween: Tween

@export
var move_time := 0.185

@onready
var sprite = $AnimatedSprite2D

var in_dialoge := false

var origin_pos: Vector2

var moves_slow := false

func _ready():
	origin_pos = self.position

func set_up(activate):
	if activate:
		position = origin_pos
	visible = activate

func _physics_process(_delta):
	if !PlayerManager.in_dialog and (!sprite_pos_tween or !sprite_pos_tween.is_running()):
		if(!moves_slow):
			if Input.is_action_pressed("ui_up") and !$up.is_colliding():
				move(Vector2.UP)
			elif Input.is_action_pressed("ui_down") and !$down.is_colliding():
				move(Vector2.DOWN)
			elif Input.is_action_pressed("ui_left") and !$left.is_colliding():
				move(Vector2.LEFT)
			elif Input.is_action_pressed("ui_right") and !$right.is_colliding():
				move(Vector2.RIGHT)
		else:
			if Input.is_action_just_pressed("ui_up") and !$up.is_colliding():
				move(Vector2.UP)
			elif Input.is_action_just_pressed("ui_down") and !$down.is_colliding():
				move(Vector2.DOWN)
			elif Input.is_action_just_pressed("ui_left") and !$left.is_colliding():
				move(Vector2.LEFT)
			elif Input.is_action_just_pressed("ui_right") and !$right.is_colliding():
				move(Vector2.RIGHT)
	if Input.is_action_just_pressed("interact") and ($up.is_colliding() or $down.is_colliding() or $left.is_colliding() or $right.is_colliding()):
		interact()

func move(dir: Vector2):
	global_position += dir * tile_size
	sprite.global_position -= dir * tile_size
	
	if sprite_pos_tween:
		sprite_pos_tween.kill()
	sprite.play("walk")
	sprite_pos_tween = create_tween()
	sprite_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_pos_tween.tween_property(sprite, "global_position", global_position, move_time).set_trans(Tween.TRANS_SINE)
	sprite_pos_tween.finished.connect(stop_walk)

func stop_walk():
	if sprite.is_playing():
		sprite.stop()

func interact():
	var coll_obj = get_collision_object()
	if(!coll_obj):
		return
	PlayerManager.start_dialog(coll_obj.page_index, coll_obj.line_index)

func get_collision_object():
	if $up.is_colliding():
		return $up.get_collider()
	if $down.is_colliding():
		return $down.get_collider()
	if $right.is_colliding():
		return $right.get_collider()
	if $left.is_colliding():
		return $left.get_collider()
