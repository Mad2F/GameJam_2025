extends Node2D
class_name EphemeralLightSource

@onready var light_source: LightSource = $LightSource
@export var life_span: float = 1.0
var age: float
var initial_intensity: float
var initial_radius: float

func _ready() -> void:
	age = 0.0
	light_source.intensity =initial_intensity 
	light_source.radius =initial_radius
	
func _process(delta: float) -> void:
	age += delta
	var progression = clamp((life_span - age) / life_span, 0.0, 1.0)
	light_source.intensity = lerp(0.0, initial_radius, progression)
	light_source.updateIntensity()
	if(age > life_span):
		light_source.queue_free()
		queue_free()
