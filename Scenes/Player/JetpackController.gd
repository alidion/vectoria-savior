extends Node

@export var has_jetpack = true
@export var jetpack_usage_speed = 25
@export var jetpack_refill_speed = 100
@export var max_jetpack_energy = 100

var is_jetpack_cooldown = false

signal on_energy_changed(value: int)


func _ready():
	$JetpackCooldown.timeout.connect(_on_jetpack_cooldown_timeout)


var energy: int = 100:
	set(new_value):
		energy = new_value
		on_energy_changed.emit(new_value)
	get:
		return energy

func use(delta) -> bool:
	if energy > 0 and not is_jetpack_cooldown:
		energy -= jetpack_usage_speed * delta
		return true
	elif energy == 0:
		is_jetpack_cooldown = true
		if $JetpackCooldown.is_stopped():
			$JetpackCooldown.start()

	return false

func refill(delta):
	if energy < max_jetpack_energy and not is_jetpack_cooldown:
		energy += jetpack_refill_speed * delta
	if energy == max_jetpack_energy and not $JetpackCooldown.is_stopped():
		$JetpackCooldown.stop()

func _on_jetpack_cooldown_timeout():
	is_jetpack_cooldown = false
