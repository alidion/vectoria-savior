extends Area2D

var direction: Vector2 = Vector2.LEFT
@export var speed = 500

signal hit(laser, body)

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	hit.emit(self, body)
	queue_free()


func _on_area_entered(area:Area2D):
	if area is HitBoxComponent:
		area.damage(1)
	queue_free()
