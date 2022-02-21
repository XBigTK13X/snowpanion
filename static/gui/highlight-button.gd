extends Node

static func build(texture):
	var button = TextureButton.new()
	button.connect("mouse_entered", SC.Static.HighlightButton, "highlight", [button])
	button.connect("mouse_exited", SC.Static.HighlightButton, "normal", [button])
	button.connect("pressed", SC.Static.HighlightButton, "darken", [button])
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.texture_normal = texture
	normal(button)
	return button

static func highlight(node):
	node.set_modulate(SC.Settings.HighlightButtonHighlight)

static func darken(node):
	node.set_modulate(SC.Settings.HighlightButtonDarken)

static func normal(node):
	node.set_modulate(SC.Settings.HighlightButtonNormal)
