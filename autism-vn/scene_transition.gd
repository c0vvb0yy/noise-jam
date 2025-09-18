extends CanvasLayer

@onready var anim : AnimationPlayer = $AnimationPlayer

var changing_to_net = true
var scene_key : int
var fade_out_animation : String
var page_index: int
var line_index: int
var new_bg: String

func _ready():
	for node in get_children():
		if node is AnimationPlayer:
			return
		node.visible = false

func only_show_animation_rect(animation: String):
	for node in get_children():
		if node is AnimationPlayer: 
			continue
		if node.name == animation:
			node.visible = true
		else:
			node.visible = false

func start_change_scene(animation: String, chaging_to_NET: bool, next_scene_key: int, fade_out_anim: String, next_page: int, next_line: int, new_background: String):
	#$Glitch.visible = false
	#$Melt.visible = true
	only_show_animation_rect(animation)
	changing_to_net = chaging_to_NET
	scene_key = next_scene_key
	fade_out_animation = fade_out_anim
	page_index = next_page
	line_index = next_line
	new_bg = new_background
	if(anim.is_connected("animation_finished", go_ahead)):
		anim.disconnect("animation_finished", go_ahead)
	anim.connect("animation_finished", on_anim_finished)
	anim.play(animation)
	#await anim.animation_finished

func on_anim_finished(_anim_name = null):
	GameWorld.game_stage.set_background(new_bg)
	for object in $/root/StageRoot/StageContainer/GameStage/LineReader/Objects.get_child(scene_key).get_children():
		if changing_to_net: 
			object.activate()
		else: object.deactivate()
	$/root/StageRoot/StageContainer/GameStage/LineReader/Player.visible = true if changing_to_net else false
	
	finish_change_scene()

func finish_change_scene(_anim_name = null):
	#$Glitch.visible = true
	#$Melt.visible = false
	#get_tree().change_scene_to_file(target)
	only_show_animation_rect(fade_out_animation)
	if(anim.is_connected("animation_finished", on_anim_finished)):
		anim.disconnect("animation_finished", on_anim_finished)
	anim.connect("animation_finished", go_ahead)
	anim.play(fade_out_animation)
	#return await anim.animation_finished

func go_ahead(_anim_name = null):
	if(!changing_to_net): 
		Parser.read_page(page_index, line_index)
	Parser.function_acceded()
	only_show_animation_rect("RESET")
