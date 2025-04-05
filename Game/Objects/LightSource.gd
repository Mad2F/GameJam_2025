extends Node2D

@export var radius: float = 100.0
@export var flicker: float = 0.0
@export var offset: Vector2 = Vector2(0.0, 0.0)

var level_shadow: LevelShadow 
var last_position: Vector2

func _ready() -> void:
	last_position = get_parent().position
	level_shadow = get_tree().get_root().get_node(get_tree().current_scene.name +"/LevelShadow")	
	if(level_shadow):
		level_shadow.add_light_source(get_parent().name, get_parent().position + offset, radius, 1.0, flicker)

func _exit_tree() -> void:
	if(level_shadow):
		level_shadow.remove_light_source(get_parent().name)

func _process(delta: float) -> void:
	if(level_shadow && get_parent().position != last_position):
		level_shadow.set_light_position(get_parent().name, get_parent().position + offset)
	last_position = get_parent().position
