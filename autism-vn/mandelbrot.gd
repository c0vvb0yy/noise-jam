extends ColorRect
class_name Kaleidoscope
@export
var enable := true

var time = 0.0
var power = 0.1
var zoom = 2.0
var zoom_in = true

var count_time := true
var shader_time := 0.0

func _ready():
	var lineReader = $"../../.."
	lineReader.connect("change_to_net", stop_time)

#func _input(event):
	#if(event.is_action("ui_accept")):
		#count_time = false
		##SceneTransition.change_scene(target_scene)

func stop_time():
	count_time = false

func set_shader_time(new_shader_time: float):
	self.material.set_shader_parameter("shader_time", new_shader_time)
	
func _process(delta):
	if count_time:
		shader_time += delta
		set_shader_time(shader_time)
	if(!enable):
		return
	
	if(zoom_in):
		time += delta
		power += delta * 0.1
		if(zoom <= 0.03542935):
			zoom_in = false
	else:
		time -= delta
		power -= delta * 0.1
		if(zoom >= 9.1):
			zoom_in = true
	zoom = 6.0 / pow(time, power)
	#print(zoom)
	self.get_material().set_shader_parameter("zoom", zoom)
