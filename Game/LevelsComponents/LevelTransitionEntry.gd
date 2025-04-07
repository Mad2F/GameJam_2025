extends Node

@onready var scene = preload("res://Game/Objects/rope.tscn")
@onready var scene_instance = null

@onready var playerScene = preload("res://Game/player.tscn")
@onready var player

@export_file var previous_exit_point : String = "Main Menu" 


func _ready():
	$PlayerStartPosition.hide()
	if (Globals.previousLevel == previous_exit_point):
		_initPlayerPosition()

func _initPlayerPosition():
	player = playerScene.instantiate()
	Globals.player = player
	player.dead.connect(_onPlayerDeath)
	player.z_index = 0
	player.position = $PlayerStartPosition.global_position
	add_child(player)
	
func _onPlayerDeath():
	get_parent().get_node("ouch").visible = true
	player.position = $PlayerStartPosition.global_position	
	await get_tree().create_timer(0.2).timeout 
	get_parent().get_node("ouch").visible = false
	

func _process(_delta):
	if Input.is_action_pressed("ResetToCheckpoint") and Globals.previousLevel == previous_exit_point:
		player.position = $PlayerStartPosition.global_position	
