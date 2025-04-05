extends Node


@export var _levelName : String = "TemplateLevel"

@export_file var _audioFile = "res://Game/resources/audio/placeholder_menu_select_loop.ogg"
@export_file var _sfxFile = "res://Game/resources/audio/cave_background.ogg"

@onready var background_sfx := $BackgroundSFX

func _ready():
	print("Level " + _levelName + " _ready")
	_playMusic()
	
func _playMusic():
	$BackgroundMusic.set_stream(load(_audioFile))
	background_sfx.set_stream(load(_sfxFile))
	#$BackgroundMusic.play()
	background_sfx.play()
