extends CanvasLayer

@onready var anim : AnimationPlayer = $AnimationPlayer

func change_scene(target: String):
	$Glitch.visible = false
	$Melt.visible = true
	anim.play('melt')
	await anim.animation_finished
	$Glitch.visible = true
	$Melt.visible = false
	#get_tree().change_scene_to_file(target)
	anim.play("pixelate")
	return await anim.animation_finished

func start_change_scene():
	$Glitch.visible = false
	$Melt.visible = true
	anim.play('melt')
	await anim.animation_finished

func finish_change_scene(animation: String):
	$Glitch.visible = true
	$Melt.visible = false
	#get_tree().change_scene_to_file(target)
	anim.play(animation)
	#return await anim.animation_finished
