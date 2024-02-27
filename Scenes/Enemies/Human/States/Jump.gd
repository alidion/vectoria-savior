extends State

class_name HumanJump

@export var Human: CharacterBody2D

func Enter():
	pass

func Physics_update(_delta):
	print("jmping!!")
	Human.velocity.y = 2000
	Human.move_and_slide()
	Transitioned.emit(self, "AttackPlayer")