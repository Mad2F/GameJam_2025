extends Button

func _ready():
 	#connect the pressed signal to a function
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
