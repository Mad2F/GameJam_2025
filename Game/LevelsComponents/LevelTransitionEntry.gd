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
	get_parent().get_node("ouch_label").visible = true
	get_parent().get_node("ouch_label").z_index = 3
	get_parent().get_node("ouch_label").global_position = Vector2(0,0)
	get_parent().get_node("ouch_rect").visible = true
	get_parent().get_node("ouch_rect").z_index = 2
	get_parent().get_node("ouch_rect").global_position = Vector2(0,0)
	await get_tree().create_timer(0.2).timeout 
	get_parent().get_node("ouch").visible = false
	await get_tree().create_timer(2).timeout 
	get_parent().get_node("ouch_label").visible = false
	get_parent().get_node("ouch_rect").visible = false
	

func _process(_delta):
	if Input.is_action_pressed("ResetToCheckpoint") and Globals.previousLevel == previous_exit_point:
		player.position = $PlayerStartPosition.global_position	
