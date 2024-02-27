extends StaticBody2D

signal laser_hit(body)

var laserScn: PackedScene = preload("res://Scenes/Level Blocks/laser_from_laser_canon.tscn")

var laser_blocked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$LaserBlockedTimer.connect("timeout", _on_laser_blocked_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not laser_blocked:
		var laser = laserScn.instantiate()
		laser.position =  $Marker2D.position
		laser.connect("body_entered", _on_laser_body_entered)
		add_child(laser)
		laser_blocked = true
		$LaserBlockedTimer.start()

func _on_laser_blocked_timer_timeout():
	laser_blocked = false

func _on_laser_body_entered(body):
	laser_hit.emit(body)
