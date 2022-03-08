extends Container

var GameData = SC.Assets.game_data()

var _button
var _cycle
var _kind
var _empty

func _init(kind, cycle = false):
	rect_min_size = Vector2(35,35)
	_kind = kind
	_button = TextureButton.new()
	_button.texture_normal = SC.Assets.load("token/" + kind + '.png')
	_button.connect('pressed', self, '_press_token')
	_button.expand = true
	_button.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT)
	_button.rect_min_size = Vector2(35, 35)
	_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	_empty = kind == GameData.TOKEN.EMPTY
	_cycle = cycle

	add_child(_button)

func _press_token():
	print("pressed")
	if _cycle:
		if _kind == GameData.TOKEN.EMPTY:
			_kind = GameData.TOKEN.CIVILIAN
		elif _kind == GameData.TOKEN.CIVILIAN:
			_kind = GameData.TOKEN.THUG
		elif _kind == GameData.TOKEN.THUG:
			_kind = GameData.TOKEN.EMPTY
		_button.texture_normal = SC.Assets.load("token/" + _kind + '.png')
	else:
		if _empty:
			_empty = false
			_button.texture_normal = SC.Assets.load("token/" + _kind + '.png')
		else:
			_empty = true
			_button.texture_normal = SC.Assets.load('token/empty.png')
