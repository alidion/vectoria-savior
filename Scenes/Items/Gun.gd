extends Area2D

signal pickup(body)

func _on_body_entered(body):
	pickup.emit(body)
