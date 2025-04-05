extends Sprite2D

var display_width = ProjectSettings.get("display/window/size/viewport_width")
var display_height = ProjectSettings.get("display/window/size/viewport_height") 


func update_blur(newPos):
	material.set("shader_parameter/CircleCentre", newPos)

func _input(_event):
	update_blur(get_local_mouse_position())
