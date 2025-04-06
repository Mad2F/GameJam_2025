extends Node

var playerScene = preload("res://Game/player.tscn")
var _player : Player


func _ready():
	$PlayerStartPosition.hide()
	_initPlayerPosition()
		
	
func _initPlayerPosition():
	_player = playerScene.instantiate()
	_player.z_index = 0
	_player.position = $PlayerStartPosition.position
	add_child(_player)
