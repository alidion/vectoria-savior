extends Node2D

signal gun_pickup(body)
signal jetpack_pickup(body)

func _on_gun_pickup(body):
	if body.name == "Player":
		$Items.remove_child($Items/Gun)
	gun_pickup.emit(body)

func _on_jetpack_on_pickup(body):
	if body.name == "Player":
		$Items.remove_child($Items/Jetpack)
	jetpack_pickup.emit(body)
