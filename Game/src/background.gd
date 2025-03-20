extends Node2D

func _ready():
	#get_node("Player").game_over.connect(_on_game_over)
	get_node("ExitGame").get_cancel_button().pressed.connect(_on_exit_canceled)
	get_node("ExitGame").get_ok_button().pressed.connect(_on_exit_approved)
	get_node("GameOver").get_ok_button().pressed.connect(_on_exit_approved)
	
func _on_exit_canceled():
	get_node("ExitGame").set_visible(false)
	
func _on_game_over():
	get_node("GameOver").set_visible(true)
	
func _on_exit_approved():
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")

	
func _process(_delta):
	if Input.is_action_pressed("escape"):
		get_node("ExitGame").set_visible(true)
