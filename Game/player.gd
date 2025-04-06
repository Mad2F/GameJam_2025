extends CharacterBody2D

class_name Player

enum State {IDLE, WALKING, IN_THE_AIR, CLIMBING} 


# Animation Player child node
@onready var animation = get_node("Animation")
@onready var collider: CollisionShape2D = $CollisionShape2D  # Any given collider.
				

@onready var fall_sound := $Fall
@onready var step_sound := $Step
#@onready var falling_rock_sound := $FallingRock
@onready var rope_under_tension_sound := $RopeUnderTension

# Properties
var animation_to_play := "Idle"
var state : State = State.IDLE

const SPEED = 100.0
# About jump sound effect
const JUMP_FALL_SOUND_DRIVE := 0.65 # Between 0.0 - 1.0, 0.65 is a sweet spot
const MAX_FALL_PX := 200.0 # Max falling height (in px) for the fall sound effect 

@export var jump_height : float = 50
@export var jump_time_to_peak : float = 0.4
@export var jump_fall_time : float = 0.3

var _jump_velocity : float = - 2.0 * jump_height / jump_time_to_peak
var _jump_gravity : float = 2.0 * jump_height / (jump_time_to_peak * jump_time_to_peak)
var _fall_gravity : float = 2.0 * jump_height / (jump_fall_time * jump_fall_time)

var _last_safe_y := 0.
var _last_y_on_ground := 0.
var _last_position_on_ground := Vector2(0.,0.)

var isOnRope = false
var timeoff0 = 10
var timeoff = 0
var toRight = true

var currentFloor = null

signal dead;

@onready var scene = preload("res://Game/Objects/rope.tscn")
@onready var stone = preload("res://Game/Objects/Stone.tscn")
@onready var scene_instance = null
@onready var grapin_stone_instance = null

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
		
		if (is_on_floor()):
			if (Input.is_action_pressed("use_lantern")):
				$lanterne.visible = true
				return
			else:
				if ($lanterne.visible):
					$lanterne.visible = false
	
		# Handle Jump.
		if Input.is_action_just_pressed("move_jump") and is_on_floor():
			velocity.y = _jump_velocity #move_toward(JUMP_VELOCITY, 0, SPEED)
			state = State.IN_THE_AIR
		elif state == State.IN_THE_AIR and is_on_floor():
			state = State.IDLE
			var effect = AudioServer.get_bus_effect(2, 0)
			effect.drive = 0
			fall_sound.play()

		if (not is_on_floor()):
			if position.y - _last_safe_y > 150:
				movement = "Falling"
		else:
			# Get the input direction and handle the movement/deceleration.
			var direction = Input.get_axis("move_left", "move_right")
			if direction:
				velocity.x = direction * SPEED
				movement = "Walk"
				if not step_sound.playing and is_on_floor() :
					state = State.WALKING
					step_sound.play()
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
		
			#jump on/off rope
			if Input.is_action_just_pressed("climb"):
				print("CLIMB ON")
				var rope_down_position = calculate_rope_down_position()
				if (rope_down_position != null):
					isOnRope = true
					timeoff = timeoff0
					state = State.CLIMBING
					rope_under_tension_sound.play()
					_on_rope_down_created(rope_down_position)
					_last_position_on_ground = global_position
					global_position = rope_down_position
					toRight = !toRight
				
					set_collision_mask_value(1, true)
					set_collision_mask_value(3, true)
					#$CollisionShape2D.disabled = true
				else:
					isOnRope = false
					timeoff = 0
					print("No rope")
				return
			if Input.is_action_just_pressed("use_grapin"):
				print("GRAPIN ON")
				#isOnRope = true
				timeoff = timeoff0
				var rope_up_position = calculate_rope_up_position()
				if (rope_up_position != null):
					state = State.CLIMBING
					rope_under_tension_sound.play()
					_on_rope_up_created(rope_up_position)
					#_last_position_on_ground = global_position
					#global_position = rope_down_position
				
					set_collision_mask_value(1, true)
					set_collision_mask_value(3, true)
					#$CollisionShape2D.disabled = true
				else:
					#isOnRope = false
					timeoff = 0
					print("No grapin")
				return

	#rope movements:
	else:
		velocity.y = 0
		movement = "Climb_Idle"
		
		if Input.is_action_just_pressed("climb"):
			var potentialPosition = null
			if (global_position.y - _last_position_on_ground.y < 75):
				potentialPosition = _last_position_on_ground
			goOffRope(potentialPosition)

			return
		
		if Input.is_action_just_pressed("move_jump"):
			print("JUMP OFF")
			var jumpPos = isJumpOffFree()
			print(jumpPos)
			if (jumpPos != null):
				goOffRope(jumpPos)
			return
			
		var updown = Input.get_axis("ui_up", "ui_down")
		if updown:
			#cannot go above rope limit
			if position.y + delta * updown * SPEED >= _last_position_on_ground.y:
				velocity.y = updown * SPEED
				movement = "Climb"
	
	# All movement animations named appropriately
	if movement == "Walk":
		toRight = (velocity.x > 0)
	animation.flip_h = !toRight
	animation.play(movement)
	handleSonar()
	
	_process_fall()
	# Move character, slide at collision
	move_and_slide()
	
func calculate_rope_down_position():
	if (toRight):
		if $bottom_right.has_overlapping_bodies() == false:
			var pos = $bottom_right.global_position
			pos.x = floor($bottom_right.global_position.x / 120) * 120
			return pos
	else:
		if $bottom_left.has_overlapping_bodies() == false:
			var pos = $bottom_left.global_position
			pos.x = floor($bottom_left.global_position.x / 120) * 120
			return pos

	return null

func calculate_rope_up_position():
	print('above head ', $above_head.has_overlapping_bodies(), $jump_left.has_overlapping_bodies(), $jump_right.has_overlapping_bodies())
	if $above_head.has_overlapping_bodies() == false:
		if (toRight):
			var pos = $jump_right.global_position
			pos.x = floor($jump_right.global_position.x / 120) * 120 + 60
			return pos
		else:
			var pos = $jump_left.global_position
			pos.x = floor($jump_left.global_position.x / 120) * 120
			return pos

	return null

func isJumpOffFree():
	if (not toRight):
		if $jump_left.has_overlapping_bodies() == false:
			return $jump_left.global_position
	else:
		if $jump_right.has_overlapping_bodies() == false:
			return $jump_right.global_position

	return null

func goOffRope(pos):
	isOnRope = false
	rope_under_tension_sound.stop()
	state = State.IDLE
	timeoff = timeoff0
	set_collision_mask_value(1, true)
	set_collision_mask_value(3, false)
	#$CollisionShape2D.disabled = false
	if (pos != null):
		set_global_position(pos)
	_on_rope_destroyed()

func falls_off_rope():
	print("player falls off")
	isOnRope = false
	_on_rope_destroyed()
	set_collision_mask_value(1, true)
	set_collision_mask_value(3, false)
	
	return null

func _process_fall():
	var fall_height = int(position.y - _last_safe_y)
	if (is_on_floor() or isOnRope): #on considere la corde comme le sol d'un point de vue chute
		#if (fall_height > 0):
			#print("Aie, tombé d'une hauteur de " + str(fall_height) + " pixels") #on est tombé
		_last_safe_y = position.y 
		if fall_height > 0 and not isOnRope:
			var fall_drive = fall_height
			if fall_drive > MAX_FALL_PX:
				fall_drive = MAX_FALL_PX
			fall_drive = (fall_drive / MAX_FALL_PX) * JUMP_FALL_SOUND_DRIVE
			var effect = AudioServer.get_bus_effect(2, 0) # SFX Jump Bus -> Distorition
			effect.drive = fall_drive
			fall_sound.play()
			
		_last_safe_y = position.y 
	
	if (position.y - _last_safe_y> 120):
		print("DEAD")
		dead.emit()
		
		

func _on_rope_down_created(pos):
	scene_instance = scene.instantiate()
	add_sibling(scene_instance)
	scene_instance.set_name("Rope")
	scene_instance.set_global_position(pos)
	scene_instance.z_index = -1
	scene_instance.player_leaves_rope.connect(falls_off_rope)
	isOnRope = true

func _on_rope_up_created(pos):
	grapin_stone_instance = stone.instantiate()
	var force = Vector2(0, -300)
	var p = $grapin_right.global_position if toRight else $grapin_left.global_position
	grapin_stone_instance.position = p
	grapin_stone_instance.linear_velocity = force
	grapin_stone_instance.floor.connect(_on_floor_grapin_found)
	get_tree().get_root().get_node(get_tree().current_scene.get_path()).add_child(grapin_stone_instance)

func _on_floor_grapin_found(pos):
	grapin_stone_instance.queue_free()
	if (pos.y < global_position.y):
		pos.y = pos.y - 60
		_last_position_on_ground = pos
		if (toRight):
			_last_position_on_ground.x += 60 
		else:
			_last_position_on_ground.x -= 60
		_on_rope_down_created(pos)
	else:
		print("GRAPIN not created")

func _on_rope_destroyed():
	scene_instance.queue_free()

func handleSonar():
	if(Input.is_action_just_pressed("use_sonar")):
		var instance: Stone = stone.instantiate()
		var force = Vector2(-200.0, -300) if toRight else Vector2(200.0, -300.0)
		instance.position = position
		instance.linear_velocity = force
		get_tree().get_root().get_node(get_tree().current_scene.get_path()).add_child(instance)
