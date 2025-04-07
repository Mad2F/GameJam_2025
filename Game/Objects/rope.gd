extends Node2D

signal player_leaves_rope
@onready var rope_sound := $Rope
@onready var on_any_rope := true
@onready var timer := Timer.new()

enum State {SMALL, MEDIUM, LONG}

var state : State = State.SMALL
var toRight = true

func _ready():
	rope_sound.play()
	await get_tree().create_timer(0.2).timeout 
	if $RopeArea_low.has_overlapping_bodies() == false:
		state = State.LONG
		$RopeTexture_middle.visible = true
		await get_tree().create_timer(0.2).timeout
		$RopeTexture_low.visible = true
		$RopeArea_low.player_leaves_rope.connect(release)
		$RopeArea_low.player_on_rope.connect(grab)
		$RopeArea_low.set_collision_mask(2)
	elif $RopeArea_middle.has_overlapping_bodies() == false:
		state = State.MEDIUM
		$RopeTexture_middle.visible = true
		$RopeArea_middle.player_leaves_rope.connect(release)
		$RopeArea_middle.player_on_rope.connect(grab) 
		$RopeArea_middle.set_collision_mask(2)
	else:
		$RopeArea.player_leaves_rope.connect(release)
		$RopeArea.player_on_rope.connect(grab)
		$RopeArea.set_collision_mask(2)
	print(state)
	
	
	add_child(timer)
	timer.wait_time = 0.05
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)

func _process(_delta):
	$hook.flip_h = toRight	
		

func _exit_tree():
	print("call here destroy")
	await get_tree().create_timer(0.5).timeout 
	if $RopeTexture_low.visible == true:
		$RopeTexture_low.visible = false
		await get_tree().create_timer(0.5).timeout 
	if $RopeTexture_middle.visible == true:
		$RopeTexture_middle.visible = false
		await get_tree().create_timer(0.5).timeout 
	if $RopeTexture.visible == true:
		$RopeTexture.visible = false
		await get_tree().create_timer(0.5).timeout 
	
func grab(ropename):
	on_any_rope = true
	print("grab ",ropename)
	if not timer.is_stopped():
		timer.stop()

func release(ropename):
	print("release ", ropename)
	on_any_rope = false
	timer.start()

func _on_timer_timeout() -> void:
	if not on_any_rope:
		player_leaves_rope.emit()
