extends Node

var Assets
var Chrome
var Clone
var RNG
var Scenes

func _singleton(file):
	var node = load('res://singleton/' + file + '.gd').new()
	node.name = file
	add_child(node)
	return node

func reset():
	Assets = _singleton('assets')
	Chrome = _singleton('chrome')
	Clone = _singleton('clone')
	RNG = _singleton('rng')
	Scenes = _singleton('scenes')
