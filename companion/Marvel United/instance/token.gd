extends Container

var _texture_rect

func _init(kind):
	rect_min_size = Vector2(35,35)
	_texture_rect = TextureRect.new()
	_texture_rect.texture = SC.Assets.load("token/" + kind + '.png')
	_texture_rect.expand = true
	_texture_rect.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT)
	_texture_rect.rect_min_size = Vector2(35, 35)
	add_child(_texture_rect)