extends Node2D

signal hit_by_burning

var body_on_floor = false

func _ready():
	$Timer.timeout.connect(_on_burning_timer_finished)

func _process(_delta):
	if body_on_floor:
		if $Timer.is_stopped():
			$Timer.start()

func _on_area_2d_body_entered(_body: Node2D):
	hit_by_burning.emit()
	body_on_floor = true
	$Timer.start()

func _on_area_2d_body_exited(_body: Node2D):
	body_on_floor = false
	$Timer.stop()
	
func _on_burning_timer_finished():
	hit_by_burning.emit()