extends Node

var _deck

func _init(textures, sheet_data, index_range=null, skip_indices = null):
	var image_index = 0
	_deck = SC.Instance.Deck.new()
	for texture in textures:
		var pixels_size = null
		if 'card_size_pixels' in sheet_data:
			pixels_size = sheet_data.card_size_pixels
		var margins_size = null
		if 'card_margins' in sheet_data:
			margins_size = sheet_data.card_margins
		var card_sheet = SC.Instance.CardSheet.new(
			texture, sheet_data.card_sheet_columns, sheet_data.card_sheet_rows, pixels_size, margins_size
		)
		var cards = card_sheet.get_all()
		for card in cards:
			var skip = false
			if skip_indices != null:
				for skip_index in skip_indices:
					if skip_index == image_index:
						skip = true
			if !skip and (index_range == null or (image_index >= index_range[0] and image_index <= index_range[1])):
				_deck.add(card)
			image_index += 1

func get_deck():
	return _deck

