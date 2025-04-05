extends Node

@export var _levelName : String = "TemplateLevel"
@export var _nextLevelSceneName : String = ""
@export var _previousLevelSceneName : String = ""
@export_file var _audioFile = "res://Game/resources/audio/placeholder_menu_select_loop.ogg"
@export var tileSet : TileMapLayer

func _ready():
	print("Level " + _levelName + " _ready")
	_playMusic()
	
func _initPlayerPosition():
	print("_initPlayerPosition")
	
func _moveToLevel(levelSceneName : String):
	print("_moveToLevel " + levelSceneName)
	get_tree().change_scene_to_file(levelSceneName)
	
func _playMusic():
	print("_playMusic")
	$BackgroundMusic.set_stream(load(_audioFile))
	$BackgroundMusic.play()
