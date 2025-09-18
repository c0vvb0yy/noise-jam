extends Sprite2D
var texture_size = Vector2()

func _ready():
	if texture:
		texture_size = texture.get_size()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var world_pos = get_global_mouse_position()
		var local_pos = to_local(world_pos)
		if get_rect().has_point(local_pos):
			var uv = get_uv_from_click(local_pos)
			burnCard(uv)

func get_uv_from_click(local_click_pos: Vector2) -> Vector2:
	var top_left_pos = local_click_pos + (texture_size) / 2
	var uv = top_left_pos / (texture_size)
	return uv

func burnCard(uv):
	if material and material is ShaderMaterial:
		var tween = create_tween()
		# set the uvs in the shader
		material.set_shader_parameter("position", uv)
		# use tweens to animate the radius value
		tween.tween_method(update_radius, 0.0, 2.0, 1.5)
	 
func update_radius(value: float):
	if material:
		material.set_shader_parameter("radius", value)
