extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -50.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var velocityFallingThreshold: int = 500

var have_gun = false
var have_jetpack = false
var facing_to: Vector2 = Vector2.RIGHT
var isFalling = false

# Input signals
signal shoot_laser(pos: Vector2)

func _process(_delta):
	if Input.is_action_just_pressed("FIRE") and have_gun:
		shoot_laser.emit(position) 

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
	if Input.is_action_pressed("JUMP") and have_jetpack:
		velocity.y += JUMP_VELOCITY
		isFalling = false

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


func _on_gun_pickup(body):
	if body.name == "Player":
		$"..".remove_child($"Gun")
		have_gun = true

func die():
	$AnimationPlayer.play("die")
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
