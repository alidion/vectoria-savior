extends CharacterBody2D

const SPEED = 20.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var positions: Array
var next_position_index = 0

func _ready():
	positions = $Positions.get_children()
	print("Positions", positions)

func _physics_process(_delta):
	# if current location is same as position, change position
	if position.distance_to(positions[next_position_index].global_position) < 1:
		next_position_index = (next_position_index + 1) % positions.size()

	var current_next_position = positions[next_position_index].global_position
	var direction = (current_next_position - global_position).normalized()
	print("Direction", direction)
	velocity = direction * SPEED

	move_and_slide()
