extends Node

@export var _nextLevelSceneName : String = ""
	
func _moveToLevel():
	print("_moveToLevel " + _nextLevelSceneName)
	queue_free()
	get_tree().change_scene_to_file(_nextLevelSceneName)

func _on_next_level_transition_body_entered(body):
	if body is Player:
		call_deferred("_moveToLevel")
