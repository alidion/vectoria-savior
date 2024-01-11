extends Node2D

@export var init_level: PackedScene

var current_level: Node

func _ready():
	load_level(init_level)

func _on_change_level(level: PackedScene):
	print("Loading level: ")
	$AnimationPlayer.play("fade_to_black")
	await $AnimationPlayer.animation_finished
	remove_child(current_level)
	load_level(level)
	$AnimationPlayer.play_backwards("fade_to_black")

func load_level(level: PackedScene):
	current_level = level.instantiate()
	add_child(current_level)
	current_level.connect("level_completed", _on_change_level)
	 
