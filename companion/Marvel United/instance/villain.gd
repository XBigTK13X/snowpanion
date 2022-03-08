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

func _init(box_name, villain_name, villain_info):
	_box_name = box_name
	_villain_name = villain_name
	_villain_info = villain_info

	_dashboard = Container.new()
	_dashboard.rect_min_size = DASHBOARD_SIZE_PIXELS
	_dashboard_bg = SC.Instance.ZoomTextureButton.new(get_asset('dashboard.jpg'))
	_dashboard_bg.expand = true
	_dashboard_bg.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT)
	_dashboard_bg.rect_min_size = DASHBOARD_SIZE_PIXELS
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
