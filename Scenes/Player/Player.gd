extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -50.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var velocityFallingThreshold: int = 500
@export var has_gun = true
@export var has_jetpack = true

signal on_laser_shoot(pos: Vector2)
signal on_player_jetpack_energy_changed(value: int)
signal on_health_changed(health: int)
signal on_health_decreased()

var facing_to: Vector2 = Vector2.RIGHT
var isFalling = false
var is_dead = false

var health = 3:
	set(new_value):
		if new_value < health and health > 0:
			on_health_decreased.emit()
		health = new_value
		on_health_changed.emit(new_value)
		if health < 0 and not is_dead:
			die()
	get:
		return health

func _ready():
	$JetpackController.connect("on_energy_changed", _on_jetpack_energy_changed)

func _process(_delta):
	if Input.is_action_just_pressed("FIRE") and has_gun:
		on_laser_shoot.emit(position)
	if Input.is_action_just_pressed("ACTION"):
		on_action()

func _physics_process(delta):
	$Sprites/Gun.visible = has_gun
	$Sprites/Jetpack.visible = has_jetpack

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > velocityFallingThreshold:
			isFalling = true
	elif isFalling:
		isFalling = false
		die()

	if Input.is_action_pressed("JUMP") and has_jetpack:
		if $JetpackController.use(delta):
			use_jetpack()
	else:
		$JetpackController.refill()

	var direction = Input.get_axis("LEFT", "RIGHT")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			facing_to = Vector2.RIGHT
			$Sprites.scale = Vector2(1, 1)
		elif direction < 0:
			facing_to = Vector2.LEFT
			$Sprites.scale = Vector2(-1, 1)

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func use_jetpack():
	velocity.y = velocity.y + JUMP_VELOCITY


func die():
	if not is_dead:
		is_dead = true
		$AnimationPlayer.play("die")
		await $AnimationPlayer.animation_finished
		await get_tree().create_timer(1.0).timeout
		get_tree().reload_current_scene()

func on_action():
	for actionable in get_tree().get_nodes_in_group("Actionable"):
		# check if actionale is near player
		if "on_action" in actionable and actionable.global_position.distance_to(global_position) < 89:
			actionable.on_action()

func _on_jetpack_energy_changed(value):
	print("energy changed")
	on_player_jetpack_energy_changed.emit(value)