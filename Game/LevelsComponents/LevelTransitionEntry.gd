extends Node

@onready var scene = preload("res://Game/rope.tscn")
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
	player.z_index = 0
	player.position = $PlayerStartPosition.global_position
	add_child(player)
