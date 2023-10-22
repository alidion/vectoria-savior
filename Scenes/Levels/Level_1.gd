extends BaseLevel

@export var next_level: PackedScene

func _on_gun_pickup(_body):
	$Player.have_gun = true
	$Items.remove_child($Items/Gun)


func _on_jetpack_on_pickup(_body):
	$Player.have_jetpack = true
	$Items.call_deferred("remove_child", $Items/Jetpack)


func _on_level_end_body_entered(_body:Node2D):
	get_tree().call_deferred("change_scene_to_packed", next_level)
