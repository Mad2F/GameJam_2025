extends Node

func _ready():
	await get_tree().create_timer(5).timeout 

func _process(delta):
	if Input.is_action_pressed("enter") || Input.is_action_pressed("escape") || Input.is_action_pressed("move_jump"):
		get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
