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
@onready var error_rope_sound := $RopeError
@onready var rope_sound := $Grapin

# Properties
var animation_to_play := "Idle"
var state : State = State.IDLE

const SPEED = 120.0
# About jump sound effect
const JUMP_FALL_SOUND_DRIVE := 0.65 # Between 0.0 - 1.0, 0.65 is a sweet spot
const MAX_FALL_PX := 200.0 # Max falling height (in px) for the fall sound effect 

@export var jump_height : float = 80
@export var jump_time_to_peak : float = 0.4
@export var jump_fall_time : float = 0.3

var _jump_velocity : float = - 2.0 * jump_height / jump_time_to_peak
var _jump_gravity : float = 2.0 * jump_height / (jump_time_to_peak * jump_time_to_peak)
var _fall_gravity : float = 2.0 * jump_height / (jump_fall_time * jump_fall_time)

var _last_safe_y := 0.
var _last_position_on_ground := Vector2(0.,0.)

var _lastTimeStoneLaunched : float = 0
var _deltaTimeStone : float = 0.5

var isOnRope = false
var timeoff0 = 10
var timeoff = 0
var toRight = true

var grapin_dict = {}
var ropeToRight

var currentFloor = null

signal dead;

@onready var scene = preload("res://Game/Objects/rope.tscn")
@onready var stone = preload("res://Game/Objects/Stone.tscn")
@onready var scene_instance = null
@onready var grapin_stone_instances = [null, null, null, null, null]

# Start front idle animation on load
func _ready():
	animation.stop()
	animation.play("Walk_Idle")
	z_index = 2
	Globals.falls = 0


func _get_gravity():
	if velocity.y < 0:
		return _jump_gravity
	else:
		return _fall_gravity


func _physics_process(delta):
	if (Input.is_action_pressed("escape")):
		get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
		return
		
	var movement = "Walk_Idle"
	_lastTimeStoneLaunched += delta
	
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
				if (toRight):
					$lanterne_droite.visible = true
				else:
					$lanterne_gauche.visible = true
				return
			else:
				if ($lanterne_droite.visible):
					$lanterne_droite.visible = false
				if ($lanterne_gauche.visible):
					$lanterne_gauche.visible = false
	
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
				
			if (position.y - _last_safe_y> 175):
				print("DEAD")
				dead.emit()
				Globals.falls += 1

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
		
		if (is_on_floor()):
			#jump on/off rope
			if Input.is_action_just_pressed("climb"):
				print("CLIMB ON")
				var rope_down_position = calculate_rope_down_position()
				if (rope_down_position != null):
					isOnRope = true
					timeoff = timeoff0
					state = State.CLIMBING
					rope_sound.play()
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
					_error_sound()
					print("No rope")
				return
			if Input.is_action_just_pressed("use_grapin"):
				print("GRAPIN ON")
				#isOnRope = true
				ropeToRight = toRight
				timeoff = timeoff0
				var rope_up_position = calculate_rope_up_position()
				if (rope_up_position != null):
					state = State.CLIMBING
					rope_sound.play()
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
		velocity.x = 0
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
			if (jumpPos != null):
				print("JUMP OFF now")
				goOffRope(jumpPos)
			return
			
		var updown = Input.get_axis("move_up", "move_down")
		if updown:
			#cannot go above rope limit
			if position.y + delta * updown * SPEED >= _last_position_on_ground.y:
				velocity.y = updown * SPEED
				movement = "Climb"
			else:
				goOffRope(_last_position_on_ground)
	
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
	var pos = $bottom_right.global_position
	if (toRight):
		if $bottom_right.has_overlapping_bodies() == false:
			pos = $bottom_right.global_position
			return pos
		if $bottom_right2.has_overlapping_bodies() == false:
			pos = $bottom_right2.global_position
			return pos
		if $bottom_right3.has_overlapping_bodies() == false:
			pos = $bottom_right3.global_position
			return pos
		if $bottom_right4.has_overlapping_bodies() == false:
			pos = $bottom_right4.global_position
			return pos
	else:
		if $bottom_left.has_overlapping_bodies() == false:
			pos = $bottom_left.global_position
			return pos
		if $bottom_left2.has_overlapping_bodies() == false:
			pos = $bottom_left2.global_position
			return pos
		if $bottom_left3.has_overlapping_bodies() == false:
			pos = $bottom_left3.global_position
			return pos
		if $bottom_left4.has_overlapping_bodies() == false:
			pos = $bottom_left4.global_position
			return pos

	return null

func calculate_rope_up_position():
	if (toRight):
		var pos = $jump_right.global_position
		return pos
	else:
		var pos = $jump_left.global_position
		return pos

func isJumpOffFree():
	if (not toRight):
		if $jump_left.has_overlapping_bodies() == false:
			return $jump_left.global_position
	else:
		if $jump_right.has_overlapping_bodies() == false:
			return $jump_right.global_position

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
		

func _on_rope_down_created(pos, inverted = false):
	scene_instance = scene.instantiate()
	add_sibling(scene_instance)
	scene_instance.set_name("Rope")
	scene_instance.set_global_position(pos)
	scene_instance.z_index = 0
	scene_instance.player_leaves_rope.connect(falls_off_rope)
	scene_instance.toRight = toRight if inverted else !toRight
	isOnRope = true

func _on_rope_up_created(_pos):
	grapin_dict.clear()
	for i in range(5):
		grapin_stone_instances[i] = stone.instantiate()
		var force = Vector2(0, -300)
		var p = $grapin_right.global_position if ropeToRight else $grapin_left.global_position
		p.x += i * 10 - 30
		grapin_stone_instances[i].position = p
		grapin_stone_instances[i].linear_velocity = force
		grapin_stone_instances[i].floor.connect(_on_floor_grapin_found)
		grapin_stone_instances[i].index = i
		grapin_stone_instances[i].hide()
		get_tree().get_root().get_node(get_tree().current_scene.get_path()).add_child(grapin_stone_instances[i])

func _on_floor_grapin_found(pos, index):
	grapin_stone_instances[index].queue_free()
	if (pos.y < global_position.y):
		grapin_dict[pos] = true
	else:
		grapin_dict[pos] = false
	
	if grapin_dict.size() == 5:
		print(grapin_dict)

		var bestkey = null
		var bestpos = -1
		for key in grapin_dict:
			print(key)
			if (grapin_dict[key] == true):
				if (bestpos == -1 or (not ropeToRight and bestpos < key.x) or (ropeToRight and bestpos > key.x)):
					bestpos = key.x
					bestkey = key
		
		if bestkey != null:
			bestkey.y = bestkey.y - 60
			if (ropeToRight):
				bestkey.x -= 40
			else:
				bestkey.x += 40
				
			_last_position_on_ground = bestkey
			if (ropeToRight):
				_last_position_on_ground.x += 70 
			else:
				_last_position_on_ground.x -= 70
			print("Create Rope at ", bestkey)
			print("Last position on ground ", _last_position_on_ground)
			rope_under_tension_sound.play()
			_on_rope_down_created(bestkey, true)
			global_position.x = bestkey.x
			
		else:
			_error_sound()
			print("GRAPIN not created ")

func _on_rope_destroyed():
	scene_instance.queue_free()
	if (rope_under_tension_sound.is_playing()):
		rope_under_tension_sound.stop()

func handleSonar():
	if(Input.is_action_just_pressed("use_sonar") and _lastTimeStoneLaunched > _deltaTimeStone):
		_lastTimeStoneLaunched = 0
		var instance: Stone = stone.instantiate()
		var force = Vector2(+200.0, -260) if toRight else Vector2(-200.0, -260.0)
		instance.global_position = global_position + Vector2(30, 0) if toRight else global_position
		instance.linear_velocity = force
		get_tree().get_root().get_node(get_tree().current_scene.get_path()).add_child(instance)

func _error_sound():
	error_rope_sound.play()
