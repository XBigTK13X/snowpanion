extends Node

var GameData = SC.Assets.game_data()
var Location = SC.Assets.instance('location')
var Villain = SC.Assets.instance('villain')

var container

var villains = {}
var locations = {}

var villain_picker
var location_picker
var companion_container

var chosen_villain
var chosen_locations

var debug_companion = true

func _ready():
	container = SC.get_container()
	print('test')
	ingest_resources()
	show_villain_picker()

func ingest_resources():
	for box_name in GameData.boxes:
		var box = GameData.boxes[box_name]
		for location_name in box.locations:
			locations[box_name + '-' + location_name] = Location.new(box_name, location_name, box.locations[location_name])
		for villain_name in box.villains:
			villains[box_name + '-' + villain_name] = Villain.new(box_name, villain_name, box.villains[villain_name])

func debug_locations():
	var grid = SC.Statics.MarginGridContainer.build(6)
	for location_key in locations:
		SC.link(grid, locations[location_key])
	SC.link(container, grid)

func debug_villains():
	var grid = SC.Statics.MarginGridContainer.build(6)
	for villain_key in villains:
		var villain = villains[villain_key]
		SC.link(grid, villain.get_dashboard())
	SC.link(container, grid)

func debug_assets():
	#debug_locations()
	#debug_villains()
	pass

func show_villain_picker():
	if(debug_companion):
		return pick_villain(villains.values()[0])
	villain_picker = SC.Instance.ItemPicker.new(villains.values(), 3, self, 'pick_villain')
	SC.link(container, villain_picker)

func pick_villain(villain):
	chosen_villain = villain
	show_location_picker()

func show_location_picker():
	if(debug_companion):
		return locations_chosen([
			locations.values()[0],
			locations.values()[1],
			locations.values()[2],
			locations.values()[3],
			locations.values()[4],
			locations.values()[5]
		])
	SC.clean(villain_picker)
	location_picker = SC.Instance.ItemMultiPicker.new(locations.values(), Location.SIZE_PIXELS.y, 4, 6, funcref(self, 'locations_chosen'))
	SC.link(container, location_picker)

func locations_chosen(items):
	SC.clean(location_picker)
	chosen_locations = items
	show_companion()

func show_companion():
	var wrapper = SC.Statics.CenteredContainer().build()
	companion_container = HBoxContainer.new()
	var villain_container = VBoxContainer.new()
	var locations_container = HBoxContainer.new()

	SC.link(villain_container, [
		chosen_villain.get_dashboard(),
		chosen_villain.get_plan_deck().get_back()
	])

	var locations_rows = VBoxContainer.new()
	var locations_first_row = HBoxContainer.new()
	var locations_second_row = HBoxContainer.new()

	var threats = chosen_villain.get_threat_deck()
	threats.shuffle()
	for location in chosen_locations:
		location.set_threat(threats.draw().get_front().texture)

	SC.link(locations_first_row, [chosen_locations[0], chosen_locations[1], chosen_locations[2]])
	SC.link(locations_second_row, [chosen_locations[3], chosen_locations[4], chosen_locations[5]])
	SC.link(locations_rows, [locations_first_row, locations_second_row])
	SC.link(locations_container, locations_rows)
	SC.link(companion_container, [villain_container, locations_container])
	SC.link(wrapper, companion_container)
	SC.link(container, wrapper)

