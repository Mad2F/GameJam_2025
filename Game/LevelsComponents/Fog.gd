extends Sprite2D
class_name Fog

const LightTexture = preload("res://Game/resources/misc/light.png")
@export var LevelDimension: Vector2 = Vector2(0.0, 0.0)

var display_width = ProjectSettings.get("display/window/size/viewport_width")
var display_height = ProjectSettings.get("display/window/size/viewport_height") 

var fogImage = Image.new()
var fogTexture = ImageTexture.new()
var lightImage = LightTexture.get_image()
var light_offset = Vector2(LightTexture.get_width()/2.0, LightTexture.get_height()/2.0)

func _ready():
	var fog_image_width = display_width if(LevelDimension.x == 0) else LevelDimension.x
	var fog_image_height = display_height if(LevelDimension.y == 0) else LevelDimension.y
	fogImage = Image.create(fog_image_width, fog_image_height, false, Image.FORMAT_RGBAH)
	fogImage.fill(Color.BLACK)
	lightImage.convert(Image.FORMAT_RGBAH)

func clear_fog(coord: Vector2, light: Image):
	var light_rect = Rect2(Vector2.ZERO, Vector2(light.get_width(), light.get_height()))	
	var myoffset = Vector2(light.get_width()/2.0, light.get_height()/2.0)
	fogImage.blend_rect(light, light_rect, coord - myoffset)
	update_fog_image_texture()

func update_fog_image_texture():
	fogTexture = ImageTexture.create_from_image(fogImage)
	texture = fogTexture
