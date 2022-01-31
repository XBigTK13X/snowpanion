extends Node

var hidden_button_style = null
var deselected_button_style = null

func button(textures):
	var node = TextureButton.new()
	for key in textures.keys():
		node['texture_'+key] = textures[key]
	node.margin_left = -(textures.normal.get_width()/2)
	node.margin_top = -(textures.normal.get_height()/2)	
	node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	return node

var highlight_color = Color(1,1,1,1)
func highlight(node):
	node.set_modulate(highlight_color)

var darken_color = Color(0.5,0.5,0.5,1)
func darken(node):
	node.set_modulate(darken_color)

var normal_color = Color(0.9,0.9,0.9,0.9)
func normal(node):
	node.set_modulate(normal_color)

func highlight_on_hover_button(texture):
	var button = TextureButton.new()	
	button.connect("mouse_entered", self, "highlight", [button])
	button.connect("mouse_exited", self, "normal", [button])
	button.connect("pressed", self, "darken", [button])
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.texture_normal = texture
	normal(button)
	return button

func invisible_button():
	var node = Button.new()
	if hidden_button_style == null:
		hidden_button_style = StyleBoxFlat.new()
		hidden_button_style.bg_color = Color(0,0,0,0)
	node.add_stylebox_override("normal",hidden_button_style)
	node.add_stylebox_override("hover",hidden_button_style)
	node.add_stylebox_override("focus",hidden_button_style)
	node.add_stylebox_override("pressed",hidden_button_style)
	node.add_stylebox_override("disabled",hidden_button_style)
	node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	return node

func center_container():
	var container = CenterContainer.new()
	container.anchor_top = 0.5
	container.anchor_left = 0.5
	container.set_size(SC.Settings.display_size())
	return container

func text_button(context, text, call, args):
	var button = Button.new()
	button.text = text
	button.set('custom_fonts/font', SC.Assets.get_font('Text Button'))
	button.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	button.set_v_size_flags(Control.SIZE_EXPAND_FILL)
	button.rect_min_size = Vector2(400,200)
	button.connect("pressed", context, call, args)
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	return button

func label(text):
	var label = Label.new()
	label.set('custom_fonts/font', SC.Assets.get_font('Text Label'))
	label.text = text
	return label
