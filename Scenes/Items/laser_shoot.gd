extends Area2D

var direction: Vector2 = Vector2.LEFT
var speed = 10;

func _process(delta):
	position = direction * speed * delta
