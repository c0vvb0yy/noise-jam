extends Sprite2D
var texture_size = Vector2()

var is_burned := false
@onready
var text_label = $"../RichTextLabel"
@export
var body_text: String
var default_text :="[skew h=45000 v=1][i]Sacrifice" 

var active := false

@export
var next_page : int
@export
var next_line : int

func _ready():
	if texture:
		texture_size = texture.get_size()
	deactivate_outline()
	clear_text()

func _process(_delta):
	if is_burned || !active:
		return
	var world_pos = get_global_mouse_position()
	var local_pos = to_local(world_pos)
	if get_rect().has_point(local_pos):
		activate_outline()
		if text_label.text == default_text:
			set_text()
	else:
		deactivate_outline()
		if text_label.text == str("[skew h=45000 v=1][i]", body_text):
			clear_text()

func _input(event):
	if event is InputEventMouseButton and event.pressed and !is_burned and active:
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
		await tween.tween_method(update_radius, 0.0, 2.0, 1.5).finished
		is_burned = true
		deactivate_outline()
		Parser.function_acceded()
		Parser.read_page(next_page, next_line)
	 
func update_radius(value: float):
	if material:
		material.set_shader_parameter("radius", value)

func activate_outline():
	material.set_shader_parameter("width", 0.012 if name == "Arm"||name=="mouth" else 0.03)
	material.set_shader_parameter("progress", 1.0)

func deactivate_outline():
	material.set_shader_parameter("width", 0.0)
	material.set_shader_parameter("progress", 0.0)

func set_text():
	text_label.text = str("[skew h=45000 v=1][i]", body_text)

func clear_text():
	text_label.text = default_text
