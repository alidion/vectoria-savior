@tool
extends CharacterBody2D

@export var SPEED = 500.0

@export var health = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var positions: Array
var next_position_index = 0

func _ready():
	update_configuration_warnings()
	var markers = $Positions.get_children()
	for marker in markers:
		positions.append(marker.global_position)	

func _physics_process(_delta):
	if not Engine.is_editor_hint():
		if positions.size() > 0:
			var current_next_position = positions[next_position_index]

			if position.distance_to(current_next_position) < 2:
				next_position_index = (next_position_index + 1) % positions.size()

			var direction = (current_next_position - global_position).normalized()
			velocity = direction * SPEED

		move_and_slide()

func hit():
	health -= 1
	if health <= 0:
		queue_free()

func _get_configuration_warnings():
	var markers = $Positions.get_children()
	if markers.size() == 0:
		return ["You need to place some marks under 'Positions' for the bug to move"]
	return []