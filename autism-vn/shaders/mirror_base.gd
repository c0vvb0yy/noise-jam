extends ColorRect

var tween : Tween
func _ready():
	var timer = get_tree().create_timer(3.0)
	timer.connect("timeout", start_tween)

func start_timer():
	if(tween):
		tween.kill()
		self.material.set_shader_parameter("shine_progress", 2.5)
	var random_duration = randf_range(1.0, 3.0)
	await get_tree().create_timer(random_duration).timeout
	start_tween()
	

func start_tween():
	tween = create_tween()
	tween.tween_property(self.material,"shader_parameter/shine_progress", -1.0, randf_range(0.75, 1.3)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", start_timer)
