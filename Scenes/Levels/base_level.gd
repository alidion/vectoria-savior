extends Node2D
class_name BaseLevel

const laserScn: PackedScene = preload("res://Scenes/Items/laser_shoot.tscn")

var player_is_on_burning_floor = false

signal level_completed(nextLevel: PackedScene)

func _ready():
	setup_burning_floor()
	setup_player()
	$Hud.set_dialogue("")
	
func setup_player():
	$Player.connect("on_laser_shoot", _on_player_shoot_laser)
	$Player.connect("on_jetpack_energy_changed", _on_player_jetpack_energy_changed)
	$Player.connect("on_health_changed", _on_player_health_changed)
	$Player.connect("on_health_decreased", _on_player_health_decreased)
	$Player.jetpack_energy = 100
	$Player.health = 3

func _on_player_shoot_laser(pos):
	var laser = laserScn.instantiate()
	laser.position = pos
	laser.direction = $Player.facing_to
	$Shoots.add_child(laser)
	laser.hit.connect(_on_laser_hit)

func _on_laser_hit(laser, body):
	laser.queue_free()
	if body.has_method("hit"):
		body.hit()

func _on_player_jetpack_energy_changed(value):
	$Hud.set_jetpack_energy_progress_bar(value)

func _on_player_health_decreased():
	$Hud.health_decreased()

func _on_player_health_changed(health):
	$Hud.set_health_ui(health)

func setup_burning_floor():
	for burning_floor in get_tree().get_nodes_in_group("burning_floor"):
		burning_floor.connect("hit_by_burning", _on_hit_by_burning)

func _on_hit_by_burning():
	$Player.health -= 1
