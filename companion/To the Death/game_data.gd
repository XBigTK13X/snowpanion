extends Node

var card_sheet_columns = 4
var card_sheet_rows = 2
var card_size_mm = Vector2(63, 88)
var card_size_pixel = Vector2(card_size_mm.x * 3.5, card_size_mm.y * 3.5)
var card_margins = Vector2(4,0)

var decks = {
	monsters = {
		asset_dir = 'monsters',
		asset_range = [1, 15],
		index_range = [0, 108],
		skip_indices = null
	},
	monster_kings = {
		asset_dir = 'monster-kings',
		asset_range = [1, 8],
		index_range = [0, 56],
		skip_indices = null
	},
	hero_damage = {
		asset_dir = 'damage-reference',
		asset_range = [6, 9],
		index_range = [0, 27],
		skip_indices = [20, 21, 22, 23]
	},
	enemy_damage = {
		asset_dir = 'damage-reference',
		asset_range = [10, 11],
		index_range = [0, 15],
		skip_indices = [6, 7, 12, 13]
	},
	action_reference = {
		asset_dir = 'damage-reference',
		asset_range = [12, 12],
		index_range = [0, 1],
		skip_indices = null
	}
}
