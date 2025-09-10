extends Node

var current_input_id = 0
var input_schemes :={
	0: 'vn',
	1: 'rpg'
}

var vn := {
	'advance': [KEY_SPACE, KEY_ENTER, MOUSE_BUTTON_LEFT],
	'interact': [],
	'toggle_auto_continue': [KEY_A],
	'ui_up': [],
	'ui_left': [KEY_J],
	'ui_down': [KEY_K],
	'ui_right': [KEY_L],
}

var rpg := {
	'interact': [KEY_SPACE, KEY_ENTER, MOUSE_BUTTON_LEFT],
	'advance': [],
	'ui_up': [KEY_W, KEY_UP],
	'ui_left': [KEY_A, KEY_LEFT],
	'ui_down': [KEY_S, KEY_DOWN],
	'ui_right': [KEY_D, KEY_RIGHT],
	'toggle_auto_continue': []
}

func change_controls(id: int):
	current_input_id = id
	
	var profile = get(input_schemes[current_input_id])
	
	for action_name in profile.keys():
		change_action_key(action_name, profile[action_name])
	

func change_action_key(action_name, key_scancodes):
	erase_action_events(action_name)
	for key in key_scancodes:
		var new_event := InputEventKey.new()
		new_event.set_keycode(key)
		InputMap.action_add_event(action_name, new_event)

func erase_action_events(action_name):
	var input_events = InputMap.action_get_events(action_name)
	for event in input_events:
		InputMap.action_erase_event(action_name, event)
