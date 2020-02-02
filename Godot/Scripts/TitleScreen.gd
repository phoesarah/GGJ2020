extends Control

func _input(event):
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
	if event is InputEventMouseButton or event is InputEventKey:
		get_tree().change_scene("res://tscn/Scenes/Main.tscn")
