extends Node

@export var has_jetpack = true
@export var jetpack_usage_speed = 50
@export var max_jetpack_energy = 100

var is_jetpack_cooldown = false

signal on_energy_changed(value: int)


func _ready():
	$JetpackCooldown.timeout.connect(_on_jetpack_cooldown_timeout)


var jetpack_energy: int = 100:
	set(new_value):
		jetpack_energy = new_value
		on_energy_changed.emit(new_value)
	get:
		return jetpack_energy

func use(delta) -> bool:
	if jetpack_energy > 0 and not is_jetpack_cooldown:
		jetpack_energy -= jetpack_usage_speed * delta
		return true
	elif jetpack_energy == 0:
		is_jetpack_cooldown = true
		if $JetpackCooldown.is_stopped():
			$JetpackCooldown.start()

	return false

func refill():
	if jetpack_energy < max_jetpack_energy and not is_jetpack_cooldown:
		jetpack_energy += jetpack_usage_speed
		print("jetpack_energy: " + str(jetpack_energy))
	if jetpack_energy == max_jetpack_energy and not $JetpackCooldown.is_stopped():
		$JetpackCooldown.stop()

func _on_jetpack_cooldown_timeout():
	is_jetpack_cooldown = false
