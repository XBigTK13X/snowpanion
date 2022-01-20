extends Node

var Assets
var Chrome
var RNG

func _singleton(file):
	var node = load('res://singleton/' + file + '.gd').new()
	node.name = file
	add_child(node)
	return node

func reset():
	Assets = _singleton('assets')
	Chrome = _singleton('chrome')
	RNG = _singleton('rng')
