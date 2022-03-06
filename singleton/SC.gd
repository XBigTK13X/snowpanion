extends Node

var Assets
var Clone
var Instance
var RNG
var Scenes
var Settings
var Statics

func reset():
	Assets = _singleton('assets')
	Clone = _singleton('clone')
	Instance = _singleton('instance')
	RNG = _singleton('rng')
	Scenes = _singleton('scenes')
	Settings = _singleton('settings')
	Statics = _singleton('statics')

func _singleton(file):
	var node = load('res://singleton/' + file + '.gd').new()
	node.name = file
	if(node.has_method('static_init')):
		node.static_init()
	add_child(node)
	return node

func get_container():
	return get_node("/root/Container")

func clean(node, remove_parent=true):
	if(node == null):
		return
	if(remove_parent):
		if(node.get_parent() == null):
			return
		node.get_parent().remove_child(node)
	for n in node.get_children():
		node.remove_child(n)
	if(remove_parent):
		node.queue_free()

func remove_children(node):
	for n in node.get_children():
		node.remove_child(n)

func link(parent, child):
	if(typeof(child) == TYPE_ARRAY):
		for c in child:
			link(parent, c)
	else:
		unparent(child)
		parent.add_child(child)

func unparent(child):
	var current_parent = child.get_parent()
	if(current_parent != null):
		current_parent.remove_child(child)
