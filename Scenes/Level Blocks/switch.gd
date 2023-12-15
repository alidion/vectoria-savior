extends Node2D
class_name VectoriaSwitch

signal switch_changed(value: bool)

@export var turned_on: bool = false:
	set(value):
		turned_on = value
		turn(value)
	get:
		return turned_on
		
func turn_on():
	if not turned_on:
		turn(true)

func turn_off():
	if turned_on:
		turn(false)
	
func turn(value: bool):
	switch_changed.emit(value)
	$Sprite2D.flip_v = value

func _get_configuration_warnings():
	return ["whaaat"]

func on_action():
	turned_on = !turned_on