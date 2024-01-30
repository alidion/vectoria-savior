@uid("uid://bstd7twj1eg5s") # Generated automatically, do not modify.
extends Area2D

class_name HitBoxComponent

@export var health_component : HealthComponent

func damage(amount:int):
	if health_component:  
		health_component.damage(amount)