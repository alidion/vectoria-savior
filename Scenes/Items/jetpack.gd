extends Area2D

signal on_pickup(body)

func _on_body_entered(body):
	on_pickup.emit(body)
