extends Container

var GameData = SC.Assets.game_data()
var Token = SC.Assets.instance('token')

const SIZE_PIXELS = Vector2(300, 300)

var _box_name
var _location_name
var _texture_rect
var _threat
var _slot_count
var _start_civilians
var _start_thugs
var _people_row
var _threat_token

const SLOTS_X = [
	120,
	120, #1
	120, #2
	89, #3
	65, #4
	41, #5
	17  #6
]

func _init(box_name, location_name, location_info):
	rect_min_size = Vector2(300,300)

	_box_name = box_name
	_location_name = location_name
	_slot_count = location_info[0]
	_start_civilians = location_info[1]
	_start_thugs = location_info[2]

	_texture_rect = TextureRect.new()
	_texture_rect.texture = SC.Assets.load(box_name + "/location/" + location_name + '.jpg')
	_texture_rect.expand = true
	_texture_rect.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT)
	_texture_rect.rect_min_size = SIZE_PIXELS

	add_child(_texture_rect)

	_people_row = HBoxContainer.new()
	_people_row.set_alignment(BoxContainer.ALIGN_CENTER)
	_people_row.set("custom_constants/separation", 10)
	_people_row.set_position(Vector2(SLOTS_X[_slot_count], 42))

	for _ii in range(0, _start_civilians):
		var token = Token.new(GameData.TOKEN.CIVILIAN)
		SC.link(_people_row, token)
	for _ii in range(0, _start_thugs):
		var token = Token.new(GameData.TOKEN.THUG)
		SC.link(_people_row, token)

	add_child(_people_row)

	_threat_token = Token.new(GameData.TOKEN.THREAT)
	_threat_token.set_position(Vector2(10, 245))
	add_child(_threat_token)

func get_picker_button():
	var button_texture = ImageTexture.new()
	button_texture.create_from_image(_texture_rect.texture.get_data())
	button_texture.set_size_override(SIZE_PIXELS)
	return SC.Static.HighlightButton.build(button_texture)

func set_threat(threat_card):
	threat_card.set_position(Vector2(50,138))
	threat_card.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT)
	threat_card.rect_min_size = Vector2(230,165)
	add_child(threat_card)