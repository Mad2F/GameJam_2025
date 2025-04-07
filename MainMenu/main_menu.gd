extends Node2D


@onready var menu_select := $MenuSelect
@onready var menu_validation := $MenuValidation


func _ready():
	var newgame = get_node("NewGame")
	var credits = get_node("Credits")
	var tutorial = get_node("Tutorial")
	newgame.pressed.connect(_new_game_button_pressed)
	credits.pressed.connect(_credits_button_pressed)
	tutorial.pressed.connect(_new_game_tutorial_button_pressed)


func _new_game_button_pressed():
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Game/Levels/Goal_new_game.tscn")

func _new_game_tutorial_button_pressed():
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Game/Levels/Goal.tscn")
	
func _credits_button_pressed():
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Credits/Credits.tscn")


func _on_button_mouse_entered() -> void:
	menu_select.play()


func _on_button_pressed() -> void:
	menu_validation.play()
