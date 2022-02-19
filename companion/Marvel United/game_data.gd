extends Node

var card_size_pixels = Vector2(210,335)

# Slots are count, start civilian, start thug

var boxes = {
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
		villains = [
			"red_skull",
			"taskmaster",
			"ultron"
		]
	}
}
