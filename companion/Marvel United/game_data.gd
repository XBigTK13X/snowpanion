extends Node

var card_size_pixels = Vector2(248,346.5)
var turned_card_size_pixels = Vector2(346.5,248)

var threat_deck_info = {
	index_range = [0,5],
	card_sheet_rows = 3,
	card_sheet_columns = 2
}

var plan_deck_info = {
	index_range = [0,11],
	card_sheet_rows = 2,
	card_sheet_columns = 6
}

const TOKEN = {
	CIVILIAN = 'civilian',
	HEALTH = 'health',
	THREAT = 'threat',
	THUG = 'thug'
}

var boxes = {
	# location array is for slots -> [count, start civilian, start thug]
	core = {
		locations = {
			avengers_mansion = [3, 1, 0],
			avengers_tower = [3, 1, 0],
			central_park = [5, 2, 2],
			new_york_police_headquarters = [4, 2, 1],
			shield_headquarters = [4, 1, 1],
			shield_helicarrier = [4, 1, 2],
			stark_labs = [4, 1, 2],
			times_square = [5, 2, 1]
		},
		villains = {
			red_skull = {
				health = [4, 8, 11],
				threat_health = [5, 0, 4, 0, 6, 0]
			},
			taskmaster = {
				health = [2, 4, 6],
				threat_health = [0, 0, 0, 0, 0, 0]
			},
			ultron = {
				health = [4, 8, 11],
				threat_health = [0, 0, 4, 0, 4, 0]
			}
		}
	}
}
