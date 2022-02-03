extends Node

func load_companion(game_name):
	return get_tree().change_scene("res://companion/" + game_name + "/" + game_name + ".tscn")

func close_companion():
	return get_tree().change_scene("res://GamePicker.tscn")
