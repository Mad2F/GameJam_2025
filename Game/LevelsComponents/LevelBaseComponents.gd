extends Node

@export var _levelName : String = "TemplateLevel"
@export_file var _audioFile = "res://Game/resources/audio/placeholder_menu_select_loop.ogg"

func _ready():
	print("Level " + _levelName + " _ready")
	_playMusic()
	
func _playMusic():
	print("_playMusic")
	$BackgroundMusic.set_stream(load(_audioFile))
	$BackgroundMusic.play()
