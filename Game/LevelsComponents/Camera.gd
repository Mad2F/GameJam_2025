extends Camera2D

@onready var playerCharacter: Player 

func _ready() -> void:
	playerCharacter = get_tree().get_root().get_node(get_tree().current_scene.name +"/PlayerStartPosition/Player")

func _physics_process(delta: float) -> void:
	if(position.y - playerCharacter.position.y < -ProjectSettings.get("display/window/size/viewport_height") / 3 * 2):
		position.y = playerCharacter.position.y - ProjectSettings.get("display/window/size/viewport_height") / 3 * 2
	if(position.y - playerCharacter.position.y > ProjectSettings.get("display/window/size/viewport_height") / 3 * 2):
		position.y = min(playerCharacter.position.y + ProjectSettings.get("display/window/size/viewport_height") / 3 * 2, 0)
