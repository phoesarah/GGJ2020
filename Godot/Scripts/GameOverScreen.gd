extends Control
var timer

func _onready():
	timer = 2

func _input(event):
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
	if event is InputEventMouseButton or event is InputEventKey:
		if get_node("Timer").time_left<.1:
			get_tree().change_scene("res://tscn/Scenes/Main.tscn")
