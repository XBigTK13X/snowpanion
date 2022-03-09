extends TextureButton

var _texture
var _modal

func _init(texture, min_size = null):
	_texture = texture
	self.texture_normal = texture
	var _connect_err = connect('pressed', self, '_show_modal')
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	expand = true
	set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT)
	rect_min_size = texture.get_size()
	if min_size != null:
		rect_min_size = min_size
	var modal_texture = ImageTexture.new()

	# FIXME This is an inefficient workaround for AtlasTexture not supporting scaling
	# This might work better in Godot 4.0, which allows for calling get_image() on a AtlasTexture region
	if 'atlas' in texture:
		var scaled_texture = ImageTexture.new()
		scaled_texture.create_from_image(texture.atlas.get_data())
		scaled_texture.set_size_override(Vector2(texture.atlas.get_width() * SC.Settings.Card_Zoom_Multiply, texture.atlas.get_height() * SC.Settings.Card_Zoom_Multiply))
		modal_texture = AtlasTexture.new()
		modal_texture.set_atlas(scaled_texture)
		var size = texture.get_region().size
		var position = texture.get_region().position
		var scaled_region = Rect2(position.x * SC.Settings.Card_Zoom_Multiply, position.y * SC.Settings.Card_Zoom_Multiply, size.x * SC.Settings.Card_Zoom_Multiply, size.y * SC.Settings.Card_Zoom_Multiply)
		modal_texture.set_region(scaled_region)
		modal_texture.set_filter_clip(true)
	else:
		modal_texture.create_from_image(texture.get_data())

	_modal = TextureButton.new()
	_modal.texture_normal = modal_texture
	_modal.connect('pressed', self, '_hide_modal')
	_modal.expand = true
	_modal.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT)
	_modal.rect_min_size = Vector2(1920, 1080)
	_modal.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _show_modal():
	var container = SC.get_container()
	SC.link(container, _modal)

func _hide_modal():
	SC.unparent(_modal)

func get_texture():
	return _texture
