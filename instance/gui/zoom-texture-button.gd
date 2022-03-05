extends TextureButton

var _texture
var _modal

func _init(texture):
	_texture = texture
	self.texture_normal = texture
	var _connect_err = connect('pressed', self, '_show_modal')
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


	var modal_texture = ImageTexture.new()
	modal_texture.create_from_image(texture.get_data())

	_modal = TextureButton.new()
	_modal.texture_normal = modal_texture
	_modal.connect('pressed', self, '_hide_modal')
	_modal.expand = true
	_modal.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT)
	_modal.rect_min_size = Vector2(1920, 1080)
	_modal.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _show_modal():
	print("showing")
	var container = SC.get_container()
	SC.link(container, _modal)

func _hide_modal():
	print("hiding")
	SC.unparent(_modal)

func get_texture():
	return _texture
