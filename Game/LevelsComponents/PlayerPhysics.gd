extends Node

var playerScene = preload("res://Game/player.tscn")
var _player : Player
@onready var scene = preload("res://Game/rope.tscn")
@onready var scene_instance = null

func _ready():
	$PlayerStartPosition.hide()
	_initPlayerPosition()
	_player.createRope.connect(_on_rope_created)
	_player.destroyRope.connect(_on_rope_destroyed)
	
func _initPlayerPosition():
	_player = playerScene.instantiate()
	_player.z_index = 0
	_player.position = $PlayerStartPosition.position
	add_child(_player)

func _on_rope_created(pos):
	scene_instance = scene.instantiate()
	scene_instance.set_name("Rope")
	scene_instance.set_global_position(pos)
	scene_instance.z_index = 2
	print("GOTIT")
	add_child(scene_instance)

func _on_rope_destroyed():
	scene_instance.queue_free()
	print("FOLD")
