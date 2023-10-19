extends StaticBody2D

@export var health: int = 3
 
func hit():
	health -= 1
	if health <= 0:
		queue_free()
