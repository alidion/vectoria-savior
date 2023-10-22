extends Node2D
class_name BaseLevel

const laserScn: PackedScene = preload("res://Scenes/Items/laser_shoot.tscn")

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