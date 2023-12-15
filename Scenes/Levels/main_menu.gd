extends Control


func _on_button_pressed():
	print("loading scene")
	get_tree().change_scene_to_file("res://Scenes/Levels/game_controller.tscn")
