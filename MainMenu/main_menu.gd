extends Node2D

func _ready():
	var newgame = get_node("NewGame")
	var credits = get_node("Credits")
	var tutorial = get_node("Tutorial")
	newgame.message_button_pressed.connect(_on_message_button_pressed)
	credits.message_button_pressed.connect(_on_message_button_pressed)
	tutorial.message_button_pressed.connect(_on_message_button_pressed)
	

func _on_message_button_pressed(message: String):
	get_tree().change_scene_to_file("res://" + message)
