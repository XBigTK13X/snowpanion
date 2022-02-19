extends Node

static func build(textures):
	var button = TextureButton.new()
	for key in textures.keys():
		button['texture_'+key] = textures[key]
	button.margin_left = -(textures.normal.get_width()/2)
	button.margin_top = -(textures.normal.get_height()/2)
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	return button