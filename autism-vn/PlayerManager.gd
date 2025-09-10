extends Node

var in_dialog := false


func start_dialog(page_index: int, line_index: int):
	in_dialog = true
	InputManager.change_controls(0)
	Parser.read_page(page_index, line_index)

func exit_dialog():
	in_dialog = false
	InputManager.change_controls(1)
