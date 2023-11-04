extends Node2D
class_name BaseLevel

const laserScn: PackedScene = preload("res://Scenes/Items/laser_shoot.tscn")

signal level_completed(nextLevel: PackedScene)

func _ready(): 
	$Player.connect("on_laser_shoot", _on_player_shoot_laser)
	_level_ready()

func _level_ready():
	pass

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
