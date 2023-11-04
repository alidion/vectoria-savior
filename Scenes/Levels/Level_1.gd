extends BaseLevel

@export var next_level: PackedScene

func _ready():
	super()
	$Player.has_gun = false
	$Player.has_jetpack = false

func _on_gun_pickup(_body):
	$Player.has_gun = true
	$Items.remove_child($Items/Gun)


func _on_jetpack_on_pickup(_body):
	$Player.has_jetpack = true
	$Items.call_deferred("remove_child", $Items/Jetpack)

func _on_level_end_body_entered(_body:Node2D):
	level_completed.emit(next_level)
