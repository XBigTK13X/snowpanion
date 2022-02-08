extends Node

var _deck

func _init(textures, index_range, game_data, skip_indices = null):
	var image_index = 0
	_deck = SC.Instance.Deck.new()
	for texture in textures:
		var card_sheet = SC.Instance.CardSheet.new(texture, game_data.card_sheet_columns, game_data.card_sheet_rows, game_data.card_size_pixel, game_data.card_margins)
		var cards = card_sheet.get_all()
		for card in cards:
			var skip = false
			if skip_indices != null:
				for skip_index in skip_indices:
					if skip_index == image_index:
						skip = true
			if !skip and image_index >= index_range[0] and image_index <= index_range[1]:
				_deck.add(card)
			image_index += 1

func get_deck():
	return _deck

