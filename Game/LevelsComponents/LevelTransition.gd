extends Node

@export var nextLevelSceneName : String = ""
@export var currentLevelSceneName : String = ""
	
func _moveToLevel():
	Globals.previousLevel = currentLevelSceneName
	print("_moveToLevel " + nextLevelSceneName)
	queue_free()
	get_tree().change_scene_to_file(nextLevelSceneName)

func _on_next_level_transition_body_entered(body):
	if body is Player:
		call_deferred("_moveToLevel")
