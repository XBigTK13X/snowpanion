extends Node

var _box_name
var _location_name
var _texture_rect
var _threat
var _slot_count
var _start_civilians
var _start_thugs

func _init(box_name, location_name, location_info):
	_box_name = box_name
	_location_name = location_name
	_texture_rect = TextureRect.new()
	_texture_rect.texture = SC.Assets.load(box_name + "/location/" + location_name + '.jpg')
	_slot_count = location_info[0]
	_start_civilians = location_info[1]
	_start_thugs = location_info[2]


