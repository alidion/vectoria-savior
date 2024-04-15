@tool
extends CharacterBody2D

var SPEED = 500.0

@export var health = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var positions: Array
var inverted_positions: Array

var next_position

func _ready():
	update_configuration_warnings()
	var markers = $Positions.get_children()
	for marker in markers:
		positions.append(marker.global_position)
	next_position = positions.pop_front()

func _physics_process(_delta):
	if not Engine.is_editor_hint():
		if position.distance_to(next_position) < 5:
			inverted_positions.push_front(next_position)
			if positions.size() == 0:
				positions = inverted_positions
				inverted_positions = []
			next_position = positions.pop_front()

		var direction = global_position.direction_to(next_position)
		velocity = direction * SPEED

		move_and_slide()

func _get_configuration_warnings():
	var markers = $Positions.get_children()
	if markers.size() == 0:
		return ["You need to place some marks under 'Positions' for the bug to move"]
	return []
