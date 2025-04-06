extends Area2D

signal player_on_rope(message: String)
signal player_leaves_rope(message: String)
signal tilemap_encountered()

func _ready():
	body_entered.connect(_on_body_area_entered)
	body_exited.connect(_on_body_area_exited)
	
func _on_body_area_entered(area: Node2D) -> void:
	if area is Player:
		player_on_rope.emit(name)
		print(name, " player encountered")
	elif area is TileMapLayer:
		tilemap_encountered.emit()
		print(name, " tile encountered")
	else:
		print(name, area)
	
func _on_body_area_exited(area: Node2D) -> void:
	if area is Player:
		player_leaves_rope.emit(name)
		print(name, " player exited")
