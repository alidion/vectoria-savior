extends StaticBody2D

var active: bool = true

func _ready():
	for operator in get_children():
		if operator is VectoriaSwitch:
			operator.switch_changed.connect(_on_switch_changed)

func _on_switch_changed(_value: bool):
	active = !active
	var tween = get_tree().create_tween()
	if active:
		$CollisionShape2D.disabled = false
		tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1, 1), 0.5)
	else:
		tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1, 0), 0.5)
		await tween.finished
		$CollisionShape2D.disabled = true