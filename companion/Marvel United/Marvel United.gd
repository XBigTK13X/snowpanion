extends Node

var GameData = SC.Assets.game_data()
var Location = SC.Assets.instance('location')
var Villain = SC.Assets.instance('villain')

var container

var villains = {}
var locations = {}

func _ready():
	container = get_node("/root/Container")
	ingest_resources()
	debug_assets()

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
	debug_villains()
	pass
