extends Node

@export
var target_scene: String

var count_time :bool = true
var shader_time : float = 0.0

@export
var shader :ColorRect

#func _input(event):
	#if(event.is_action("ui_accept")):
	#	count_time = false
	#	SceneTransition.change_scene(target_scene)

func _process(delta):
	if count_time:
		shader_time += delta
	set_shader_time(shader_time)

func set_shader_time(shader_time: float):
	shader.material.set_shader_parameter("shader_time", shader_time)
