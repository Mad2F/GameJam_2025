extends Node2D

@export var radius: float = 100.0
@export var flicker: float = 0.0
@export var offset: Vector2 = Vector2(0.0, 0.0)
@export var intensity: float = 1.0

const LightTexture = preload("res://Game/resources/misc/light.png")
var lightImage = LightTexture.get_image()
var level_shadow: LevelShadow 
var level_fog: Fog
var last_position: Vector2 

func _ready() -> void:
	last_position = get_parent().position
	level_shadow = get_tree().get_root().get_node(get_tree().current_scene.name +"/LevelShadow")
	level_fog = get_tree().get_root().get_node(get_tree().current_scene.name +"/Fog")	
	lightImage.resize(lightImage.get_width() * intensity, lightImage.get_height() * intensity,Image.INTERPOLATE_BILINEAR)
	lightImage.convert(Image.FORMAT_RGBAH)
	if(level_shadow):
		level_shadow.add_light_source(get_parent().name, get_parent().position + offset, radius, 1.0, flicker)

func _exit_tree() -> void:
	if(level_shadow):
		level_shadow.remove_light_source(get_parent().name)

func _process(delta: float) -> void:
	if(get_parent().position != last_position):
		if(level_shadow):
			level_shadow.set_light_position(get_parent().name, get_parent().position + offset)
		if(level_fog):
			level_fog.clear_fog(get_parent().position + offset, lightImage)
	last_position = get_parent().position
