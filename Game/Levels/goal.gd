extends Node2D

var timeout = 10

func _process(_delta):
	if (timeout > 0):
		timeout = timeout - 1
		return
	if Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://Game/Levels/LevelTutorial.tscn")
