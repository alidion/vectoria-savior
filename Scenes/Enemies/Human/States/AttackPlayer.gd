extends State

class_name AttackPlayer

@export var Human: CharacterBody2D
@export var PlayerDetectArea: Area2D
@export var CenterRaycast: RayCast2D
@export var Gun: GunComponent

var is_facing_right: bool = true

var player: Player

func Enter():
	PlayerDetectArea.body_exited.connect(on_player_leave)
	player = get_tree().get_first_node_in_group("player")

func Update(_delta):
	Gun.shoot(Vector2.RIGHT if is_facing_right else Vector2.LEFT)

func Physics_update(_delta):
	if Human.global_position.x > player.global_position.x:
		is_facing_right = false
	else:
		is_facing_right = true
	
	if Human.global_position.y > player.global_position.y:
		Transitioned.emit(self, "HumanJump")

	if is_facing_right:
		Human.scale = Vector2(1, 1)
	else:
		Human.scale = Vector2( - 1, 1)

func on_player_leave(body):
	if body.name == "Player":
		Transitioned.emit(self, "Idle")
