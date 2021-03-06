extends Node

var GameData = SC.Assets.game_data()

var DASHBOARD_SIZE_PIXELS = Vector2(525, 233)

var _box_name
var _villain_name
var _villain_info

var _dashboard
var _dashboard_bg
var _plan_deck
var _threat_deck

var _current_plan
var _current_plan_texture_rect

var _plan_container
var _plan_button

func _init(box_name, villain_name, villain_info):
	_box_name = box_name
	_villain_name = villain_name
	_villain_info = villain_info

	_dashboard = Container.new()
	_dashboard.rect_min_size = DASHBOARD_SIZE_PIXELS
	_dashboard_bg = SC.Instance.ZoomTextureButton.new(get_asset('dashboard.jpg'), DASHBOARD_SIZE_PIXELS)
	_dashboard.add_child(_dashboard_bg)

	var threat_deck_info = SC.Clone.deep(GameData.threat_deck_info)
	threat_deck_info.card_size_pixels = GameData.location_threat_size_pixels
	var threat_card_book = SC.Instance.CardBook.new(get_asset('threat.jpg'), threat_deck_info, threat_deck_info.index_range)
	_threat_deck = threat_card_book.get_deck()

	var plan_deck_info = SC.Clone.deep(GameData.plan_deck_info)
	plan_deck_info.card_size_pixels = GameData.card_size_pixels
	var plan_card_book = SC.Instance.CardBook.new(get_asset('plan.jpg'), plan_deck_info, plan_deck_info.index_range)
	_plan_deck = plan_card_book.get_deck()
	_plan_deck.set_back(get_asset('plan-back.jpg'))

	_current_plan_texture_rect = TextureRect.new()
	_current_plan_texture_rect.texture = null

	_plan_container = HBoxContainer.new()
	_plan_button = TextureButton.new()
	_plan_button.texture_normal = _plan_deck.get_back().texture
	_plan_button.connect('pressed', self, 'next_plan', [])
	SC.link(_plan_container, [_plan_button, _current_plan_texture_rect])

func get_asset(relative_path):
	return SC.Assets.load(_box_name + '/villain/' + _villain_name + '/' + relative_path)

func get_dashboard():
	return _dashboard

func get_threat_deck():
	return _threat_deck

func get_plan_deck():
	return _plan_deck

func get_picker_button():
	var button_texture = ImageTexture.new()
	button_texture.create_from_image(_dashboard_bg.get_texture().get_data())
	button_texture.set_size_override(DASHBOARD_SIZE_PIXELS)
	return SC.Static.HighlightButton.build(button_texture)

func next_plan():
	_current_plan = _plan_deck.draw()
	if _current_plan == null:
		return
	_current_plan_texture_rect.texture = _current_plan.get_front().texture

func get_plan_container():
	return _plan_container