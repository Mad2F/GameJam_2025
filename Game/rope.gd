extends Node2D

signal player_leaves_rope

func _ready():
	print("deploy !")
	$AnimatedSprite2D.play("deploy")
	await($AnimatedSprite2D.animation_finished)
	$Area2D.player_leaves_rope.connect(transmit)


func _exit_tree():
	$AnimatedSprite2D.play("retract")
	await($AnimatedSprite2D.animation_finished)

func transmit():
	player_leaves_rope.emit()
