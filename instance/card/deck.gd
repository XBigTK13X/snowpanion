extends Node

# The 0th element in _cards is the top of the deck.
# The size-th element is the bottom.
var _cards
var _deck_back

func _init(cards=[]):
	_cards = cards

func get_card(index):
	return _cards[index]

func shuffle():
	_cards.shuffle()

func top_card():
	if _cards.size() > 0:
		return _cards[0]
	else:
		return null

func put_on_top(card):
	_cards.push_front(card)

func count_label():
	var label = SC.Static.Label.build('')
	if(_cards.size() == 1):
		label.text = str(_cards.size()) + " Card"
	else:
		label.text = str(_cards.size()) + " Cards"
	return label

func remove(index):
	_cards.remove(index)

func draw_top():
	if _cards.size() <= 0:
		return null
	return _cards.pop_front()

func draw():
	return draw_top()

func add(cards):
	if cards.has_method('size'):
		_cards.append_array(cards)
	else:
		_cards.push_back(cards)

func clear():
	_cards = []

func size():
	return _cards.size()

func get_all_cards():
	return _cards

func build_picker(context=null, select_action=null, grid_columns=7):
	var scroll_container = ScrollContainer.new()
	scroll_container.rect_min_size = Vector2(1900, 1060)
	scroll_container.get_v_scrollbar().rect_min_size.x = 35
	scroll_container.get_h_scrollbar().rect_min_size.y = 35
	scroll_container.margin_top = 10
	scroll_container.margin_left = 10
	var card_grid = SC.Static.MarginGridContainer.build(grid_columns)

	for card in _cards:
		var button = card.get_front_button()
		if(context != null && select_action != null):
			button.connect('pressed', context, select_action, [card])
		card_grid.add_child(button)

	SC.link(scroll_container, card_grid)
	return scroll_container

func set_back(stream_texture):
	var texture_data: Image = stream_texture.get_data()
	var texture_image = ImageTexture.new()
	texture_image.create_from_image(texture_data)
	var texture_size = Vector2(_cards[0].get_front().rect_min_size.x, _cards[0].get_front().rect_min_size.y)
	texture_image.set_size_override(texture_size)
	var texture_rect = TextureRect.new()
	texture_rect.texture = texture_image
	texture_rect.expand = true
	texture_rect.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT)
	texture_rect.rect_min_size = texture_size
	for card in _cards:
		card.set_back(texture_rect)
	_deck_back = texture_rect

func get_back():
	return _deck_back
