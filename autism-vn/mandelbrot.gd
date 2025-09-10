extends ColorRect

@export
var enable := true

var time = 0.0
var power = 0.1
var zoom = 2.0
var zoom_in = true
func _process(delta):
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
