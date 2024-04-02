@tool
extends Node2D

class_name GunComponent

@export var laserScn: PackedScene

@export_flags("Player", "Enemy")
var mask: int

@onready var marker: Marker2D = get_child(0)

var can_shoot = true

var shoot_container: Node

func _ready():
	shoot_container = get_tree().get_first_node_in_group("shoots")
	update_configuration_warnings()
	$GunCoolDown.timeout.connect(_on_cooldown_timeout)

func shoot(direction: Vector2):
	if can_shoot:
		var bullet = laserScn.instantiate() as Area2D
			
		bullet.position = marker.global_position + Vector2(50, 0)
		bullet.direction = direction
		can_shoot = false
		$GunCoolDown.start()
		shoot_container.add_child(bullet)

func _on_cooldown_timeout():
	can_shoot = true

func _get_configuration_warnings():
	if not get_child(0) is Marker2D:
		return ["First child must be the marker2d from where the shoot will begin"]
	return []
