extends Node

var Assets
var Chrome
var Clone
var RNG
var Scenes
var Settings

func reset():
	Assets = _singleton('assets')
	Chrome = _singleton('chrome')
	Clone = _singleton('clone')
	RNG = _singleton('rng')
	Scenes = _singleton('scenes')
	Settings = _singleton('settings')

func clean(node):
	if(node == null):
		return
	if(node.get_parent() == null):
		return
	node.get_parent().remove_child(node)
	for n in node.get_children():
		node.remove_child(n)
	node.queue_free()

func remove_children(node):
	for n in node.get_children():
		node.remove_child(n)

func link(parent, child):
	var current_parent = child.get_parent()
	if(current_parent != null):
		current_parent.remove_child(child)
	parent.add_child(child)

func _singleton(file):
	var node = load('res://singleton/' + file + '.gd').new()
	node.name = file
	if(node.has_method('static_init')):
		node.static_init()
	add_child(node)
	return node
