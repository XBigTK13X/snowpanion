extends Node

var Assets
var Chrome
var Clone
var RNG
var Scenes
var Settings

func _singleton(file):
	var node = load('res://singleton/' + file + '.gd').new()
	node.name = file
	if(node.has_method('static_init')):
		node.static_init()
	add_child(node)
	return node

func reset():
	Assets = _singleton('assets')
	Chrome = _singleton('chrome')
	Clone = _singleton('clone')
	RNG = _singleton('rng')
	Scenes = _singleton('scenes')
	Settings = _singleton('settings')
