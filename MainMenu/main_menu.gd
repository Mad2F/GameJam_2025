extends Node2D


@onready var menu_select := $MenuSelect
@onready var menu_validation := $MenuValidation


func _ready():
	var newgame = get_node("NewGame")
	var credits = get_node("Credits")
	var tutorial = get_node("Tutorial")
	newgame.message_button_pressed.connect(_on_message_button_pressed)
	credits.message_button_pressed.connect(_on_message_button_pressed)
	tutorial.message_button_pressed.connect(_on_message_button_pressed)


func _on_message_button_pressed(message: String):
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://" + message)


func _on_button_mouse_entered() -> void:
	menu_select.play()


func _on_button_pressed() -> void:
	menu_validation.play()
