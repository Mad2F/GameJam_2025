extends Camera2D

@onready var playerCharacter: Player 
@export var levelBoundary : Rect2
var cameraBoundary: Rect2

func _ready() -> void:
	#playerCharacter = get_tree().get_root().get_node(get_tree().current_scene.name +"/PlayerStartPosition/Player")
	cameraBoundary = Rect2()
	cameraBoundary.position = levelBoundary.position 
	cameraBoundary.end = levelBoundary.end - Vector2(ProjectSettings.get("display/window/size/viewport_height") ,ProjectSettings.get("display/window/size/viewport_height") )
	playerCharacter = Globals.player
	if (get_parent() != null and get_parent().get_node("help") != null):
		get_parent().get_node("help").set_position(Vector2(0,0))
		get_parent().get_node("help").z_index = 35

func _physics_process(_delta: float) -> void:
	if (playerCharacter != null):
		position.x = clamp(playerCharacter.position.x- ProjectSettings.get("display/window/size/viewport_height") / 2, cameraBoundary.position.x, cameraBoundary.end.x)
		position.y = clamp(playerCharacter.position.y - ProjectSettings.get("display/window/size/viewport_height") / 2, cameraBoundary.position.y, cameraBoundary.end.y)
	if (get_parent() != null and get_parent().get_node("help") != null):
		var helpPos = position
		helpPos.x += ProjectSettings.get("display/window/size/viewport_height") / 1.85
		helpPos.y += 0 #ProjectSettings.get("display/window/size/viewport_width") / 1.7
		get_parent().get_node("help").set_position(helpPos)
	#if(position.y - playerCharacter.position.y < -ProjectSettings.get("display/window/size/viewport_height") / 3 * 2):
	#if(position.y - playerCharacter.position.y > ProjectSettings.get("display/window/size/viewport_height") / 3 * 2):
		#position.y = min(playerCharacter.position.y + ProjectSettings.get("display/window/size/viewport_height") / 3 * 2, 0)
