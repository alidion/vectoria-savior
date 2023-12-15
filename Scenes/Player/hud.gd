extends CanvasLayer

var color_red: Color = Color("ff0000")
var color_white: Color = Color.WHITE

@onready var input_map = [
	{
		"action": "LEFT",
		"ui": %"Left Arrow"
	},
	{
		"action": "RIGHT",
		"ui": %"Right Arrow"
	},
	{
		"action": "JUMP",
		"ui": %"Jump Button"
	},
	{
		"action": "FIRE",
		"ui": %"Fire Button"
	},
]

func _process(_delta):
	color_pressed_key()
	

func color_pressed_key():
	for input_control in input_map:
		if Input.is_action_pressed(input_control["action"]):
			input_control["ui"].modulate = color_red
		else:
			input_control["ui"].modulate = color_white

func set_jetpack_energy_progress_bar(value):
	%"Jetpack Energy".value = value

func set_health_ui(value):
	var HealthIcons = %HealthIconsContainer.get_children()

	for healthIcon in HealthIcons:
		healthIcon.visible = false

	for health in range(value):
		HealthIcons[health-1].visible = true

func health_decreased():
	%HitIndicator.modulate = %HitIndicator.modulate + Color(0,0,0,0.48)
	await get_tree().create_timer(0.1).timeout
	%HitIndicator.modulate = %HitIndicator.modulate * Color(1,1,1,0)

func set_dialogue(text):
	%Dialogue.text = text