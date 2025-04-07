extends CanvasLayer
class_name Map

@onready var map_foreground: TextureRect = $MapHidden
@export var map_name: String
const LightTexture = preload("res://Game/resources/misc/light.png")
const MapLevel1Texture = preload("res://Game/resources/graphics/map_level1.png")
const MapLevel2Texture = preload("res://Game/resources/graphics/map_level2.png")
const MapTutoTexture = preload("res://Game/resources/graphics/map_tuto.png")
const MapHiddenTexture = preload("res://Game/resources/graphics/map.png")
var lightImage = LightTexture.get_image()
var light_offset = Vector2(LightTexture.get_width()/2.0, LightTexture.get_height()/2.0)
var mask_image: Image
var radius: float = 0.3
var isVisible: bool = false
var transition: float = 0.0
var origCoord: Vector2

func _ready():
	lightImage.resize(lightImage.get_width() * radius, lightImage.get_height() * radius, Image.INTERPOLATE_NEAREST)
	lightImage.convert(Image.FORMAT_RGBAH)
	mask_image = Image.create(get_correct_map().get_image().get_width(), get_correct_map().get_image().get_height(), false, Image.FORMAT_RGBAH)
	mask_image.fill(Color(0.0,0.0,0.0,0.0))
	origCoord = map_foreground.position

func clear_map(coord: Vector2):
	var light_rect = Rect2(Vector2.ZERO, Vector2(lightImage.get_width(), lightImage.get_height()))		
	var off  = Vector2(lightImage.get_width()/2.0, lightImage.get_height()/2.0)
	mask_image.blend_rect(lightImage, light_rect, coord - off)	
	update_map_texture()

func update_map_texture():
	var map_image = MapHiddenTexture.get_image()
	var map_full_image = get_correct_map().get_image()
	var full_rect = Rect2(Vector2.ZERO, Vector2(map_image.get_width(), map_image.get_height()))	
	map_image.convert(Image.FORMAT_RGBAH)
	map_full_image.convert(Image.FORMAT_RGBAH)
	map_image.blend_rect_mask(map_full_image, mask_image, full_rect, Vector2.ZERO)
	var map_texture = ImageTexture.create_from_image(map_image)
	map_foreground.texture = map_texture

func _process(delta: float) -> void:
	if(Globals.player):
		match get_tree().current_scene.name:
			"Tutorial":
				clear_map(Vector2(Globals.player.position.x / 1100 * MapTutoTexture.get_image().get_width(), Globals.player.position.y / 1800 * MapTutoTexture.get_image().get_height()))
			"Biome1_Level1":
				clear_map(Vector2(Globals.player.position.x / 2300 * MapLevel1Texture.get_image().get_width(), Globals.player.position.y / 3400 * MapLevel1Texture.get_image().get_height()))
			"Biome2_Level1":
				clear_map(Vector2(Globals.player.position.x / 2300 * MapLevel2Texture.get_image().get_width(), Globals.player.position.y / 2800 * MapLevel2Texture.get_image().get_height()))

	if(transition > 0.0):
		transition = clamp( transition - delta , 0.0, 10.0 )
		map_foreground.modulate.a =  1.0 - transition if isVisible else transition
		map_foreground.position = origCoord + Vector2.DOWN *  30.0  * ((1.0 -transition)  if !isVisible else transition) 
	
	if(Input.is_action_just_pressed("map")):
		isVisible = !isVisible
		transition = 1.0 - transition

func get_correct_map():
	match get_tree().current_scene.name:
		"Tutorial":
			return MapTutoTexture
		"Biome1_Level1":
			return MapLevel1Texture
		"Biome2_Level1":
			return MapLevel2Texture
