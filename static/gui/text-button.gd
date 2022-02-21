extends Node

static func build(context, text, call, args):
	var button = Button.new()
	button.text = text
	button.set('custom_fonts/font', SC.Assets.get_font('Text Button'))
	button.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	button.set_v_size_flags(Control.SIZE_EXPAND_FILL)
	button.rect_min_size = Vector2(400,200)
	button.connect("pressed", context, call, args)
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	return button