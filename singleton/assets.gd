extends Node

var fonts = {}

func static_init():
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://asset/font/Bitstream Vera Sans/Vera.ttf")
	dynamic_font.size = 32
	fonts['Vera'] = dynamic_font
	fonts['Text Button'] = dynamic_font
	fonts['Text Label'] = dynamic_font

func get_font(font):
	return fonts[font]

func load(companion_name, asset_name):
	return load("res://companion/"+companion_name+"/asset/"+asset_name)
