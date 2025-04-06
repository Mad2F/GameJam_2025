extends Node2D

signal player_leaves_rope
@onready var rope_sound := $Rope
@onready var on_any_rope := true
@onready var timer := Timer.new()

func _ready():
	rope_sound.play()
	print("deploy !")
	deploy()
	#$AnimatedSprite2D.play("deploy")
	#await($AnimatedSprite2D.animation_finished)
	$RopeArea.player_leaves_rope.connect(release)
	$RopeArea_middle.player_leaves_rope.connect(release)
	$RopeArea_low.player_leaves_rope.connect(release)
	$RopeArea.player_on_rope.connect(grab)
	$RopeArea_middle.player_on_rope.connect(grab)
	$RopeArea_low.player_on_rope.connect(grab)
	
	add_child(timer)
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)

func deploy():
	await get_tree().create_timer(0.2).timeout 
	if $RopeArea_middle.has_overlapping_bodies() == false:
		$RopeTexture_middle.visible = true
		await get_tree().create_timer(0.2).timeout 
	if $RopeArea_low.has_overlapping_bodies() == false:
			$RopeTexture_low.visible = true

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
	
func grab():
	on_any_rope = true
	if not timer.is_stopped():
		timer.stop()

func release():
	on_any_rope = false
	timer.start()

func _on_timer_timeout() -> void:
	if not on_any_rope:
		player_leaves_rope.emit()
