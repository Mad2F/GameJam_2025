extends Node

var playerScene = preload("res://Game/player.tscn")
var _player : Player

func _ready():
	_initPlayerPosition()
	
func _process(_delta):
	print(_player.position)
	
func _initPlayerPosition():
	print("_initPlayerPosition")
	_player = playerScene.instantiate()
	_player.position = $PlayerStartPosition.position
	add_child(_player)
