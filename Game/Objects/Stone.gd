extends RigidBody2D
class_name Stone

var activated: bool = false
var forced: bool = false
var ephemeralLight: PackedScene = preload("res://Game/Objects/EphemeralLightSource.tscn")
var gravity = 1.0
var index = -1

signal floor(message: Vector2, int)

func _physics_process(delta: float) -> void:
	apply_central_force(Vector2.DOWN * delta * gravity)

func _on_body_entered(_body: Node) -> void:
	print("before ", _body.name)
	if(activated and not forced):
		return
	activated = true
	print("after ", _body.name)
	var instance: EphemeralLightSource = ephemeralLight.instantiate();
	instance.position = position
	instance.life_span = 2.0
	instance.initial_intensity = 5.0
	instance.initial_radius = 500.0
	floor.emit(global_position, index)
	get_tree().get_root().get_node(get_tree().current_scene.get_path()).add_child(instance)
	queue_free()

func _on_body_exited(_body: Node) -> void:
	print("exit ", _body.name)
	if(forced):
		forced = false
