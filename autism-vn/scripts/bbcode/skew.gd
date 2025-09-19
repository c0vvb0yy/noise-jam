@tool
extends RichTextEffect
class_name Skew

var bbcode = "skew"
var set_glyphs = [""]
var shuffled = false

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var horizontal_magnitude = char_fx.env.get("h", 1)
	var vertical_magnitude = char_fx.env.get("v", 1)
	char_fx.offset.x = horizontal_magnitude * sin(Vector2(char_fx.elapsed_time, char_fx.elapsed_time).dot(Vector2(12.34067, 94.2436))) / 100000
	#print(char_fx.offset.x)
	#print(char_fx.elapsed_time)
	char_fx.offset.y += randf_range(0, vertical_magnitude)
	return true
