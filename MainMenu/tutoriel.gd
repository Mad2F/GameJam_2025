extends Button

signal message_button_pressed(message: String)

func _ready():
 	#connect the pressed signal to a function
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	message_button_pressed.emit("") # also godot 4.x
	#TODO
