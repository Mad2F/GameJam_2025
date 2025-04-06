extends CanvasLayer
class_name Map

@onready var map_foreground: TextureRect = $MapHidden
const LightTexture = preload("res://Game/resources/misc/light.png")
const MapTexture = preload("res://Game/resources/misc/map.png")
const MapHiddenTexture = preload("res://Game/resources/misc/mapHidden.png")
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
	mask_image = Image.create(MapTexture.get_image().get_width(), MapTexture.get_image().get_height(), false, Image.FORMAT_RGBAH)
	mask_image.fill(Color(0.0,0.0,0.0,0.0))
	origCoord = map_foreground.position

func clear_map(coord: Vector2):
	var light_rect = Rect2(Vector2.ZERO, Vector2(lightImage.get_width(), lightImage.get_height()))		
	var off  = Vector2(lightImage.get_width()/2.0, lightImage.get_height()/2.0)
	mask_image.blend_rect(lightImage, light_rect, coord - off)	
	update_map_texture()

func update_map_texture():
	var map_image = MapHiddenTexture.get_image()
	var map_full_image = MapTexture.get_image()
	var full_rect = Rect2(Vector2.ZERO, Vector2(map_image.get_width(), map_image.get_height()))	
	map_image.convert(Image.FORMAT_RGBAH)
	map_full_image.convert(Image.FORMAT_RGBAH)
	map_image.blend_rect_mask(map_full_image, mask_image, full_rect, Vector2.ZERO)
	var map_texture = ImageTexture.create_from_image(map_image)
	map_foreground.texture = map_texture

func _process(delta: float) -> void:
	#TO_DO récupérer la référence du joueur et clear_map() en fonction de sa position et du niveau actuel

	if(transition > 0.0):
		transition = clamp( transition - delta , 0.0, 10.0 )
		map_foreground.modulate.a =  1.0 - transition if isVisible else transition
		map_foreground.position = origCoord + Vector2.DOWN *  30.0  * ((1.0 -transition)  if !isVisible else transition) 
	
	if(Input.is_action_just_pressed("map")):		
		isVisible = !isVisible
		transition = 1.0 - transition
