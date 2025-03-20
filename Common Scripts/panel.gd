extends Node2D

func _process(delta):
	if Input.is_action_pressed("enter") || Input.is_action_pressed("escape"):
		get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
