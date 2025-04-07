extends Camera2D

@onready var playerCharacter: Player 

func _ready() -> void:
	#playerCharacter = get_tree().get_root().get_node(get_tree().current_scene.name +"/PlayerStartPosition/Player")
	playerCharacter = Globals.player
	if (get_parent() != null and get_parent().get_node("help") != null):
		get_parent().get_node("help").set_position(Vector2(0,0))
		get_parent().get_node("help").z_index = 35

func _physics_process(_delta: float) -> void:
	if (playerCharacter != null):
		position.x = playerCharacter.position.x- ProjectSettings.get("display/window/size/viewport_height") / 2
		position.y = playerCharacter.position.y - ProjectSettings.get("display/window/size/viewport_height") / 4
	if (get_parent() != null and get_parent().get_node("help") != null):
		var helpPos = position
		helpPos.x += ProjectSettings.get("display/window/size/viewport_height") / 1.85
		helpPos.y += ProjectSettings.get("display/window/size/viewport_width") / 1.7
		get_parent().get_node("help").set_position(helpPos)
	#if(position.y - playerCharacter.position.y < -ProjectSettings.get("display/window/size/viewport_height") / 3 * 2):
	#if(position.y - playerCharacter.position.y > ProjectSettings.get("display/window/size/viewport_height") / 3 * 2):
		#position.y = min(playerCharacter.position.y + ProjectSettings.get("display/window/size/viewport_height") / 3 * 2, 0)
