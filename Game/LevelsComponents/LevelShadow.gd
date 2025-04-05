extends CanvasLayer
class_name LevelShadow

var lightCoord = {}
var lightRadius =  {}
var lightBlur = {}
var lightFlicker = {}
@onready var mat: ColorRect = $foreground

func add_light_source(id: String, coord: Vector2, radius: float, blur: float, flicker: float = 0) -> void:
	lightCoord.set(id, coord)
	lightRadius.set(id, radius)
	lightBlur.set(id, blur)
	lightFlicker.set(id, flicker)
	updateShader()

func remove_light_source(id: String) -> void:
	lightCoord.erase(id)
	lightRadius.erase(id)
	lightBlur.erase(id)
	lightFlicker.erase(id)
	updateShader()

func set_light_position(id: String, coord: Vector2) -> void:
	lightCoord.set(id, coord)
	mat.material.set("shader_parameter/CircleCentre", PackedVector2Array(lightCoord.values()))

func set_light_intensity(id: String, intensity: float) -> void:
	lightRadius.set(id, intensity)
	mat.material.set("shader_parameter/CircleRadius", PackedFloat32Array(lightRadius.values()))

func updateShader() -> void:
	mat.material.set("shader_parameter/NumberOfLightSource", lightCoord.size())
	mat.material.set("shader_parameter/CircleCentre", PackedVector2Array(lightCoord.values()))
	mat.material.set("shader_parameter/CircleRadius", PackedFloat32Array(lightRadius.values()))
	mat.material.set("shader_parameter/CircleBlur", PackedFloat32Array(lightBlur.values()))
	mat.material.set("shader_parameter/FlickerStrength", PackedFloat32Array(lightFlicker.values()))
