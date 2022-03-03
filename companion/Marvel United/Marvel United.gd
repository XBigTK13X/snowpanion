extends Node

var GameData = SC.Assets.game_data()
var Location = SC.Assets.instance('location')
var Villain = SC.Assets.instance('villain')

var container

var villains = {}
var locations = {}

var villain_picker
var location_picker

var chosen_villain_name
var chosen_location_names

func _ready():
	container = get_node("/root/Container")
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
	var grid = SC.Static.MarginGridContainer.build(6)
	for location_key in locations:
		SC.link(grid, locations[location_key])
	SC.link(container, grid)

func debug_villains():
	var grid = SC.Static.MarginGridContainer.build(6)
	for villain_key in villains:
		var villain = villains[villain_key]
		SC.link(grid, villain.get_dashboard())
	SC.link(container, grid)

func debug_assets():
	#debug_locations()
	#debug_villains()
	pass

func show_villain_picker():
	villain_picker = SC.Instance.ItemPicker.new(villains.values(), 3, self, 'pick_villain')
	SC.link(container, villain_picker)

func pick_villain(villain):
	chosen_villain_name = villain._villain_name
	show_location_picker()

func show_location_picker():
	SC.clean(villain_picker)
	location_picker = SC.Instance.ItemMultiPicker.new(locations.values(), Location.SIZE_PIXELS.y, 4, 6, funcref(self, 'pick_location'))
	SC.link(container, location_picker)

func pick_location(_locations):
	SC.clean(location_picker)
