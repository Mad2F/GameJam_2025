extends Node2D

@export var _maxDisplacement : Vector2 = Vector2(50, 50)
@export var speed : float = 10
@export var moving : bool = true
var _rng = RandomNumberGenerator.new()

var _initial_position : Vector2
var _displacement : Vector2

func _ready():
	_initial_position = position

func _process(delta):
	pass
	#_displacement.x = clamp(_displacement.x + _rng.randf_range(-speed, speed) * delta, -_maxDisplacement.x, _maxDisplacement.x)
	#_displacement.y = clamp(_displacement.y + _rng.randf_range(-speed, speed) * delta, -_maxDisplacement.y, _maxDisplacement.y)
	#position = _initial_position + _displacement
