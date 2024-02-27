extends State

@export var Human: CharacterBody2D
@export var PlayerDetectArea: Area2D


func Enter():
	PlayerDetectArea.body_entered.connect(_on_player_detected)

func Physics_update(_delta):
	pass 

func _on_player_detected(body):
	print("Player detected")
	if body is Player:
		Human = body
		Transitioned.emit(self, "AttackPlayer")
