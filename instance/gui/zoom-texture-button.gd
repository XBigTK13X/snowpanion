extends TextureButton

var _texture
var _modal

func _init(texture, zoomed_texture = null):
	_texture = texture
	self.texture_normal = texture
	var _connect_err = connect('pressed', self, '_show_modal')
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


	var modal_texture = ImageTexture.new()
	# TODO This won't work for atlastexures
	# Godot 4.0 has a potential fix in get_image()
	# but that won't be backported and 4.0 is a hot mess
	# Thus a second zoomed texture for now to work around scaling an AtlasTexture
	if( zoomed_texture != null):
		modal_texture = zoomed_texture
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
	print("showing")
	var container = SC.get_container()
	SC.link(container, _modal)

func _hide_modal():
	print("hiding")
	SC.unparent(_modal)

func get_texture():
	return _texture
