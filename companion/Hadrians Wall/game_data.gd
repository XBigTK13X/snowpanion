extends Node

var card_size_pixels = Vector2(210,335)

var decks = {
	fate = {
		front = 'fate-front.jpg',
		back = 'fate-back.jpg',
		index_range = [0,47],
		card_sheet_rows = 5,
		card_sheet_columns = 10
	},
	player = {
		front = 'player-front.jpg',
		back = 'player-back-1.jpg',
		index_range = [0, 11],
		card_sheet_rows = 2,
		card_sheet_columns = 7
	},
}
