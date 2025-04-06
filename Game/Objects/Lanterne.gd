extends Node2D

@export var maxLightIntensity : float = 10.
@export var defaultLightIntensity : float = 5.
@export var maxLightradius : float = 1500
@export var defaultLightradius : float = 500
@export var timeToMaxLight : float = 10

var _lightIntensitySpeedRatio = maxLightIntensity / timeToMaxLight
var _lightRadiusSpeedRatio = maxLightradius / timeToMaxLight

func increaseLight(delta : float):
	if (Input.is_action_pressed("use_lantern")):	
		$LightSource.intensity += _lightIntensitySpeedRatio * delta
		$LightSource.radius += _lightRadiusSpeedRatio * delta
	else:
		$LightSource.intensity -= 3 * _lightIntensitySpeedRatio * delta
		$LightSource.radius -= 3 * _lightRadiusSpeedRatio * delta	
	$LightSource.update_light()
	$LightSource.intensity = clampf($LightSource.intensity, defaultLightIntensity, maxLightIntensity)
	$LightSource.radius = clampf($LightSource.radius, defaultLightradius, maxLightradius)

func _process(delta):
	increaseLight(delta)
