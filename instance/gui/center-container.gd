extends Node

static func build():
	var container = CenterContainer.new()
	container.anchor_top = 0.5
	container.anchor_left = 0.5
	container.set_size(SC.Settings.display_size())
	return container