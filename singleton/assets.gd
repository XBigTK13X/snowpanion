extends Node

var fonts = {}

var _companion_name

func static_init():
	var dynamic_font = Font.new()
	dynamic_font.font_data = load("res://asset/font/Bitstream Vera Sans/Vera.ttf")
	# TODO https://godotengine.org/article/dev-snapshot-godot-4-0-alpha-1
	#dynamic_font.size = 32
	fonts['Vera'] = dynamic_font
	fonts['Text Button'] = dynamic_font
	fonts['Text Label'] = dynamic_font

func get_font(font):
	return fonts[font]

func set_companion_name(companion_name):
	_companion_name = companion_name

func grab(asset_name):
	return load("res://companion/" + _companion_name + "/asset/" + asset_name)

func instance(asset_name):
	return load('res://companion/' + _companion_name + '/instance/' + asset_name + '.gd')

func game_data():
	return load("res://companion/" + _companion_name + "/game_data.gd").new()
