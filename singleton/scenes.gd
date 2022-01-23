extends Node

func clean(node):
	node.get_parent().remove_child(node)
	for n in node.get_children():
		node.remove_child(n)
	node.queue_free()
