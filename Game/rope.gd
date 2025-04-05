extends Node2D

func _ready():
	print("deploy !")
	$AnimatedSprite2D.play("deploy")
	await($AnimatedSprite2D.animation_finished)
	


func _exit_tree():
	print("get it back !")
	$AnimatedSprite2D.play("retract")
	await($AnimatedSprite2D.animation_finished)
