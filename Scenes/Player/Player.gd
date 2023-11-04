extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -50.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var velocityFallingThreshold: int = 500
@export var has_gun = true
@export var has_jetpack = true
@export var jetpack_usage_speed = 100
@export var max_jetpack_energy = 100

signal on_laser_shoot(pos: Vector2)
signal on_jetpack_energy_changed(value: int)

var facing_to: Vector2 = Vector2.RIGHT
var isFalling = false
var using_jetpack = false

var jetpack_energy = 100:
	set(new_value):
		jetpack_energy = new_value
		on_jetpack_energy_changed.emit(new_value)
	get:
		return jetpack_energy

func _process(_delta):
	if Input.is_action_just_pressed("FIRE") and has_gun:
		on_laser_shoot.emit(position) 

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > velocityFallingThreshold:
			isFalling = true
	elif isFalling:
		isFalling = false
		die()

	# Handle Jump.
	if has_jetpack:
		if Input.is_action_pressed("JUMP") and jetpack_energy > 0:
			use_jetpack(delta)
		else:
			refill_jetpack(delta)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("LEFT", "RIGHT")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			facing_to = Vector2.RIGHT
		elif direction < 0:
			facing_to = Vector2.LEFT
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func use_jetpack(delta):
	velocity.y += JUMP_VELOCITY
	isFalling = false
	jetpack_energy -= jetpack_usage_speed * delta

func refill_jetpack(delta):
	if jetpack_energy < max_jetpack_energy:
		jetpack_energy += jetpack_usage_speed * delta


func die():
	$AnimationPlayer.play("die")
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
