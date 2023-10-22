extends CanvasLayer

var color_red: Color = Color("ff0000")
var color_white: Color = Color.WHITE

@onready var input_map = [
	{
		"action": "LEFT",
		"ui": $"ColorRect/HBoxContainer/MarginContainer/Arrows Container/Left Arrow"
	},
	{
		"action": "RIGHT",
		"ui": $"ColorRect/HBoxContainer/MarginContainer/Arrows Container/Right Arrow"
	},
	{
		"action": "JUMP",
		"ui": $"ColorRect/HBoxContainer/MarginContainer2/Buttons Container/Jump Button"
	},
	{
		"action": "FIRE",
		"ui": $"ColorRect/HBoxContainer/MarginContainer2/Buttons Container/Fire Button"
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