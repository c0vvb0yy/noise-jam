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

func deactivate():
	visible = false
	$CollisionShape2D.disabled = true
