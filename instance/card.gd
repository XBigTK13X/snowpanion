extends Node

var _front_rect
var _back_rect

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
	return SC.Chrome.highlight_on_hover_button(_front_rect.texture)

func get_back_button():
	return SC.Chrome.highlight_on_hover_button(_back_rect.texture)

func set_back(texture_rect):
	_back_rect = texture_rect
