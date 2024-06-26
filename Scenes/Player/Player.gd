extends CharacterBody2D

class_name Player

enum Modes {JETPACK, ATTACK}

@export var WALKING_SPEED = 300.0
@export var RUNNING_SPEED = 500.0
@export var JETPACK_FORCE = -50.0
@export var MAX_JETPACK_FORCE = 1000.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var velocityFallingThreshold: int = 500
@export var has_gun = true
@export var has_jetpack = true
@export var facing_to: Vector2 = Vector2.RIGHT

var health: int = 3
var gun_component: GunComponent

signal on_laser_shoot(pos: Vector2)
signal on_player_jetpack_energy_changed(value: int)
signal on_health_changed(health: int)
signal on_health_decreased()

var isFalling = false
var is_dead = false

var current_mode: Modes = Modes.JETPACK

func _ready():
	$JetpackController.connect("on_energy_changed", _on_jetpack_energy_changed)
	$HealthComponent.health = health
	$HealthComponent.health_depleted.connect(die)
	$HealthComponent.health_changed.connect(_on_health_component_health_changed)
	gun_component = $Sprites/GunComponent

func _process(_delta):
	if not has_jetpack:
		$JetpackController.energy = 0

	if Input.is_action_just_pressed("FIRE") and has_gun and Modes.ATTACK == current_mode:
		gun_component.shoot(facing_to)
	
	if Input.is_action_just_pressed("ACTION"):
		on_action()

	if Input.is_action_just_pressed("SWITCH_MODE"):
		current_mode = Modes.JETPACK if Modes.ATTACK == current_mode else Modes.ATTACK

func _physics_process(delta):
	$Sprites/Gun.visible = has_gun and Modes.ATTACK == current_mode
	$Sprites/Jetpack.visible = has_jetpack

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > velocityFallingThreshold:
			isFalling = true
	elif isFalling:
		isFalling = false
		die()

	if Input.is_action_pressed("JUMP") and has_jetpack and Modes.JETPACK == current_mode:
		if $JetpackController.use(delta):
			use_jetpack()
	else:
		$JetpackController.refill(delta)

	var direction = Input.get_axis("LEFT", "RIGHT")

	var current_speed = WALKING_SPEED

	if Input.is_action_pressed("RUN"):
		current_speed = RUNNING_SPEED

	if direction:
		velocity.x = direction * current_speed
		if direction > 0:
			facing_to = Vector2.RIGHT
		elif direction < 0:
			facing_to = Vector2.LEFT

	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

	if facing_to == Vector2.RIGHT:
		$Sprites.scale = Vector2(1, 1)
	
	if facing_to == Vector2.LEFT:
		$Sprites.scale = Vector2( - 1, 1)

	move_and_slide()

func use_jetpack():
	if abs(velocity.y) < MAX_JETPACK_FORCE:
		velocity.y = velocity.y + JETPACK_FORCE

func die():
	if not is_dead:
		is_dead = true
		get_tree().reload_current_scene()

func on_action():
	for actionable in get_tree().get_nodes_in_group("Actionable"):
		# check if actionable is near player
		if "on_action" in actionable and actionable.global_position.distance_to(global_position) < 89:
			actionable.on_action()

func _on_jetpack_energy_changed(value):
	on_player_jetpack_energy_changed.emit(value)

func damage(amount: int):
	$HealthComponent.damage(amount)

func _on_health_component_health_changed(previous, current):
	on_health_changed.emit(current)
	if previous > current:
		on_health_decreased.emit()
