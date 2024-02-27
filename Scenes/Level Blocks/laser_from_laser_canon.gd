extends Area2D

signal on_body_entered

@export var speed: int = 500

func _ready():
	connect("body_entered", _on_body_entered)

func _physics_process(delta):
	position.y += speed * delta

func _on_body_entered(body):
	on_body_entered.emit(body)
	queue_free()