extends Area2D

class_name WaterDrop

@export_file var sound = "res://Game/resources/audio/water_drop.wav"
@export_file var sprite = "res://Game/resources/misc/water_drop.png"
@export var loop_time_second : int = -1
@export var drop_speed : int = 50
@export var collision_size : Vector2 = Vector2(5, 5)

var _initial_position : Vector2
var _last_drop = 0

func _ready():
	$AudioStreamPlayer2D.stream = load(sound)
	$Sprite2D.texture = load(sprite)
	$CollisionShape2D.scale = collision_size / $CollisionShape2D.shape.get_rect().size
	$Sprite2D.scale = collision_size / $Sprite2D.texture.get_size()
	_initial_position = global_position

func _process(delta):
	if visible:
		position.y += drop_speed * delta
	else:
		_last_drop += delta
	if _last_drop > loop_time_second:
		_doAgain()

func _destroy_with_sound():
	$AudioStreamPlayer2D.play()
	await $AudioStreamPlayer2D.finished
	queue_free()
	
func _hide_with_sound():
	visible = false
	$AudioStreamPlayer2D.play()
	await $AudioStreamPlayer2D.finished
	$CollisionShape2D.disabled = true;
	
func _doAgain():
	_last_drop = 0
	visible = true
	global_position = _initial_position
	$CollisionShape2D.disabled = false;
	
func _on_area_2d_body_entered(body):
	if loop_time_second > 0 :
		call_deferred("_hide_with_sound")
	else:	
		call_deferred("_destroy_with_sound")
