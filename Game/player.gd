extends CharacterBody2D

class_name Player

# Animation Player child node
@onready var animation = get_node("Animation")

# Properties
var animation_to_play := "Idle"

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
const SPEED = 300.0
const JUMP_VELOCITY = -1000.0

var isOnRope = false

# Start front idle animation on load
func _ready():
	animation.stop()
	animation.play("Idle")


func _physics_process(delta):
	var movement = "Idle"
	velocity = Vector2.ZERO
	var falling = false
	
	if not is_on_floor() and not isOnRope:
		velocity.y += GRAVITY
		falling = true
	
	# Handle Jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = move_toward(JUMP_VELOCITY, 0, SPEED)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		movement = "Walk"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var updown = Input.get_axis("ui_up", "ui_down")
	if not isOnRope and Input.is_action_just_pressed("climb"):
		isOnRope = true
	if isOnRope and Input.is_action_just_pressed("climb"):
		isOnRope = false
	if isOnRope:
		if updown:
			velocity.y = updown * SPEED
			movement = "Climb"
	
	
	# All movement animations named appropriately, eg "Left_Idle" or "Back_Walk"
	if movement == "Walk":
		animation.flip_h = (velocity.x < 0)
	animation.play(movement)
	
	# Move character, slide at collision
	move_and_slide()
