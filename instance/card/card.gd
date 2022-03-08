extends Node

var _front_rect
var _back_rect
var _zoomed_texture

func _init(front, back = null):
	_front_rect = front
	_back_rect = back
	if(_back_rect == null):
		_back_rect = _front_rect

func get_front():
	return _front_rect

func get_back():
	return _back_rect

func get_front_button():
	return SC.Static.HighlightButton.build(_front_rect.texture)

func get_back_button():
	return SC.Static.HighlightButton.build(_back_rect.texture)

func set_back(texture_rect):
	_back_rect = texture_rect

func get_zoomed():
	return _zoomed_texture

func set_zoomed(texture):
	_zoomed_texture = texture
