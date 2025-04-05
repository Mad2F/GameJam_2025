extends Area2D

signal player_on_rope()
signal player_leaves_rope()

@export var tiles = 0

func _ready():
	body_entered.connect(_on_body_area_entered)
	body_exited.connect(_on_body_area_exited)
	tiles = 0
	
func _on_body_area_entered(area: Node2D) -> void:
	print("area.nameThis is it")
	print(area.name)
	if area is Player:
		player_on_rope.emit()
	if area is TileMapLayer:
		tiles = tiles + 1
	
func _on_body_area_exited(area: Node2D) -> void:
	print("area.nameThis is it")
	print(area.name)
	if area is Player:
		player_leaves_rope.emit()
	if area is TileMapLayer:
		tiles = tiles - 1
