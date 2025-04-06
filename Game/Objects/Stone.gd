extends RigidBody2D
class_name Stone

var activated: bool = false
var ephemeralLight: PackedScene = preload("res://Game/Objects/EphemeralLightSource.tscn")
var gravity = 1.0

signal floor(message: Vector2)

func _physics_process(delta: float) -> void:
	apply_central_force(Vector2.DOWN * delta * gravity)

func _on_body_entered(_body: Node) -> void:
	if(activated):
		return
	activated = true
	var instance: EphemeralLightSource = ephemeralLight.instantiate();
	instance.position = position
	instance.life_span = 2.0
	instance.initial_intensity = 5.0
	instance.initial_radius = 500.0
	floor.emit(global_position)
	get_tree().get_root().get_node(get_tree().current_scene.get_path()).add_child(instance)
	queue_free()
