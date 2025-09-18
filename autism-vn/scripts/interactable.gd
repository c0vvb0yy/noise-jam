extends StaticBody2D

@export
var page_index: int

@export
var line_index: int


func _ready():
	deactivate()

func activate():
	visible = true
	$CollisionShape2D.disabled = false
	for child in get_children():
		child.visible = true

func deactivate():
	visible = false
	$CollisionShape2D.disabled = true
	for child in get_children():
		child.visible = false
