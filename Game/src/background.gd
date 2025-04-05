extends Node2D

@onready var scene = preload("res://Game/rope.tscn")
@onready var scene_instance = null

func _ready():
	#get_node("Player").game_over.connect(_on_game_over)
	get_node("ExitGame").get_cancel_button().pressed.connect(_on_exit_canceled)
	get_node("ExitGame").get_ok_button().pressed.connect(_on_exit_approved)
	get_node("GameOver").get_ok_button().pressed.connect(_on_exit_approved)
	get_node("Player").createRope.connect(_on_rope_created)
	get_node("Player").destroyRope.connect(_on_rope_destroyed)
	
func _on_exit_canceled():
	get_node("ExitGame").set_visible(false)
	
func _on_game_over():
	get_node("GameOver").set_visible(true)
	
func _on_exit_approved():
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")

	
func _process(_delta):
	if Input.is_action_pressed("escape"):
		get_node("ExitGame").set_visible(true)
		
func _on_rope_created(pos):
	scene_instance = scene.instantiate()
	scene_instance.set_name("Rope")
	scene_instance.set_global_position(pos)
	print("GOTIT")
	add_child(scene_instance)

func _on_rope_destroyed():
	scene_instance.queue_free()
	print("FOLD")
