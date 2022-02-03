extends Node

func load_companion(game_name):
	get_tree().change_scene("res://companion/" + game_name + "/" + game_name + ".tscn")

func close_companion():
	get_tree().change_scene("res://GamePicker.tscn")