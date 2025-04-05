extends Area2D

signal player_on_rope()
signal player_leaves_rope()
signal tilemap_encountered()

func _ready():
	body_entered.connect(_on_body_area_entered)
	body_exited.connect(_on_body_area_exited)
	
func _on_body_area_entered(area: Node2D) -> void:
	if area is Player:
		player_on_rope.emit()
		print(name, "Palyer encountered")
	if area is TileMapLayer:
		print(name, "Tilemap encountered")
		tilemap_encountered.emit()
	
func _on_body_area_exited(area: Node2D) -> void:
	
	print(area.name)
	if area is Player:
		print(name, "Palyer exited")
		player_leaves_rope.emit()
	if area is TileMapLayer:
		print(name, "TileMap exited")
