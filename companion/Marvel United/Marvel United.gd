extends Node

var GameData = SC.Assets.game_data()
var Location = SC.Assets.instance('location')

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
			locations[box_name+'-'+location_name] = Location.new(box_name, location_name, box.locations[location_name])
		for villain in box.villains:
			pass

func debug_locations():
	var grid = SC.Static.MarginGridContainer.build(6)
	for location_key in locations:
		SC.link(grid, locations[location_key])
	SC.link(container, grid)

func debug_assets():
	debug_locations()
	#SC.link(container, decks.player.build_picker())
	pass
