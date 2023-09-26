extends Node2D

const laserScn: PackedScene = preload("res://Scenes/Items/laser_shoot.tscn")

func _on_player_shoot_laser(pos):
	var laser = laserScn.instantiate()
	laser.position = pos
	$".".add_child(laser)
