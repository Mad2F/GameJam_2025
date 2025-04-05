extends CharacterBody2D

class_name Player

# Animation Player child node
@onready var animation = get_node("Animation")

# Properties
var animation_to_play := "Idle"

const SPEED = 300.0

@export var jump_height : float = 50
@export var jump_time_to_peak : float = 0.4
@export var jump_fall_time : float = 0.3

var _jump_velocity : float = - 2.0 * jump_height / jump_time_to_peak
var _jump_gravity : float = 2.0 * jump_height / (jump_time_to_peak * jump_time_to_peak)
var _fall_gravity : float = 2.0 * jump_height / (jump_fall_time * jump_fall_time)

var isOnRope = false
var timeoff0 = 10
var timeoff = 0
var toRight = true

signal createRope(message: Vector2)
signal destroyRope()

# Start front idle animation on load
func _ready():
	animation.stop()
	animation.play("Walk_Idle")
	
func _get_gravity():
	if velocity.y < 0:
		return _jump_gravity
	else:
		return _fall_gravity


func _physics_process(delta):
	var movement = "Walk_Idle"
	
	#Small timeoff for playability
	if (timeoff > 0):
		timeoff = timeoff - 1
		return
	
	#Player is available
	#If not on rope :
	
	if not isOnRope:
		#add gravity
		if not is_on_floor():
			velocity.y += _get_gravity() * delta
	
		# Handle Jump.
		if Input.is_action_just_pressed("move_jump") and is_on_floor():
			velocity.y = _jump_velocity #move_toward(JUMP_VELOCITY, 0, SPEED)
			print("JUMP")

		# Get the input direction and handle the movement/deceleration.
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED
			movement = "Walk"
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		#jump on/off rope
		if Input.is_action_pressed("climb"):
			print("CLIMB ON")
			isOnRope = true
			timeoff = timeoff0
			createRope.emit(calculate_rope_position())
			$CollisionShape2D.disabled = true
			return

	#rope movements:
	else:
		movement = "Climb_Idle"
		
		if Input.is_action_pressed("climb"):
			print("CLIMB OFF")
			isOnRope = false
			timeoff = timeoff0
			destroyRope.emit()
			$CollisionShape2D.disabled = false
			return
			
		var updown = Input.get_axis("ui_up", "ui_down")
		if updown:
			velocity.y = updown * SPEED
			movement = "Climb"
	
	
	# All movement animations named appropriately
	if movement == "Walk":
		animation.flip_h = (velocity.x < 0)
		toRight = (velocity.x < 0)
	animation.play(movement)
	
	# Move character, slide at collision
	move_and_slide()

func calculate_rope_position():
	var pos = position
	#if (toRight):
	#	pos.x -= 10
	#else:
	#	pos.x += 50
	return pos
