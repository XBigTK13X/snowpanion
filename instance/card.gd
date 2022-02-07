extends Node

var _front_texture
var _back_texture

func _init(front_texture, back_texture=null):
	_front_texture = front_texture
	_back_texture = back_texture
	if(_back_texture == null):
		_back_texture = _front_texture
	
func get_front():
	return _front_texture

func get_back():
	return _back_texture
