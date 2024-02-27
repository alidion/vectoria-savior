extends Node2D

class_name HealthComponent

signal health_depleted
signal health_changed(previous, value)

@export var MAX_HEALTH = 3

var health:
	get:
		return health
	set(value):
		var previous = health
		health = value
		health_changed.emit(previous, value)
		if health <= 0:
			health_depleted.emit()
			die()
		
func _ready():
	health = MAX_HEALTH

func damage(amount: int):
	health -= amount

func die():
	get_parent().queue_free()