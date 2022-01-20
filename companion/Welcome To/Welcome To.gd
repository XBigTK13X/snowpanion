extends Node

var ConstructionDeck = load('res://companion/Welcome To/instance/construction-deck.gd')

var container
var ai_picker_container
var expansion_picker_container
var companion_container

var selected_ai_name
var selected_expansion_name

var turn_states = []

var fence_numbers = [1,2,3,5,5,6,6,7,8,8,9,10,10,11,11,13,14,15]
var temp_agency_numbers = [3,4,6,7,8,9,10,12,13]
var pool_numbers = [3,4,6,7,8,9,10,12,13]
var real_estate_agent_numbers = [1,2,4,5,5,6,7,7,8,8,9,9,10,11,11,12,14,15]
var bis_numbers = [3,4,6,7,8,9,10,12,13]
var park_numbers = [1,2,4,5,5,6,7,7,8,8,9,9,10,11,11,12,14,15]

var solo_plans = {
	solo = {
		asset = "front", atlas_index = 6
	},
	n1 = {
		asset = "front", atlas_index = 5
	},
	n2 = {
		asset = "front", atlas_index = 8
	},
	n3 = {
		asset = "front", atlas_index = 7
	}
}

# Points are top->bottom, left column->right column
var solo_ais = {
	cog_1 = {
		goals = [false,false,true], points = [1,1,1,1,2,2], asset="front", atlas_index=2, nudge = Vector2(15,0)
	},
	cog_2 = {
		goals = [true, true, true], points = [3,1,1,1,1,1], asset="back", atlas_index=2, nudge = Vector2(15,0)
	},
	cog_3 = {
		goals = [false,true,false], points = [0,5,3,1,3,2], asset="front", atlas_index=1, nudge = Vector2(5,0)
	},
	cog_4 = {
		goals = [true, false, true], points = [2,3,1,3,2,2], asset="back", atlas_index=1, nudge = Vector2(5,0)
	},
	cog_5 = {
		goals = [true,true,false], points = [1,2,3,3,4,2], asset="front", atlas_index=0, nudge = Vector2(-10,0)
	},
	cog_6 = {
		goals = [false,true,true], points = [4,3,2,2,1,4], asset="back", atlas_index=0, nudge = Vector2(0,5)
	},
	alan = {
		goals = [true, true, true], points = [3,2,1,2,2,2], asset="back", atlas_index=3, nudge = Vector2(-10,10)
	},
	alex = {
		goals = [false,false,false], points = [2,4,1,2,3,2], asset="front", atlas_index=3, nudge = Vector2(0,0)
	},
	ann = {
		goals = [true,false,false], points = [3,5,3,1,4,2], asset="front", atlas_index=4, nudge = Vector2(10,0)
	},
	ben = {
		goals = [true, true, true], points = [3,4,2,3,3,3], asset="back", atlas_index=4, nudge = Vector2(10,10)
	},
}

var expansions = {
	none = {display="None", bonus_points=0},
	halloween = {display="Halloween", bonus_points=0},	
	doomsday = {display="Nuclear Doomsday", bonus_points=0},		
	spring = {display="Spring / Easter", bonus_points=0},
	summer = {display="Summer Ice Cream", bonus_points=0},
	winter = {display="Winter Wonderland", bonus_points=0},
	outbreak = {display="Zombie Outbreak", bonus_points=0}
}

func _ready():
	SC.reset()
	container = get_node("/root/Container")
	show_ai_picker()
	
func show_ai_picker():
	var front_texture = SC.Assets.load("Welcome To", "front-solo.jpg")
	var back_texture = SC.Assets.load("Welcome To", "back-solo.jpg")
	
	ai_picker_container = GridContainer.new()
	ai_picker_container.set_columns(5)
	container.add_child(ai_picker_container)
	
	for solo_ai_name in solo_ais:
		var atlas_texture = AtlasTexture.new()
		var solo_ai = solo_ais[solo_ai_name]
		var texture_column = (solo_ai.atlas_index % 3)
		var texture_row = (solo_ai.atlas_index / 3)		
		if solo_ai.asset == "front":
			atlas_texture.set_atlas(front_texture)
		else:
			atlas_texture.set_atlas(back_texture)
		atlas_texture.set_region(Rect2(15 + (texture_column * (210 + 10)) + solo_ai.nudge.x, 15 + (texture_row * (320 + 30)) + solo_ai.nudge.y, 210, 320))
		atlas_texture.set_filter_clip(true)
		var margin = 50
		atlas_texture.set_margin(Rect2(margin,margin,margin,margin))
		solo_ais[solo_ai_name].texture = TextureRect.new()
		solo_ais[solo_ai_name].texture.texture = atlas_texture
		var ai_button = SC.Chrome.highlight_on_hover_button(atlas_texture)
		ai_button.connect("pressed", self, "_on_solo_ai_pressed", [solo_ai_name])
		ai_picker_container.add_child(ai_button)
	
func _on_solo_ai_pressed(solo_ai_name):
	selected_ai_name = solo_ai_name
	remove_child(ai_picker_container)
	show_expansion_picker()

func show_expansion_picker():
	expansion_picker_container = GridContainer.new()
	expansion_picker_container.set_columns(3)
	container.add_child(expansion_picker_container)
	
	for expansion_name in expansions:
		var expansion = expansions[expansion_name]
		var expansion_button = Button.new()
		expansion_button.text = expansion.display
		expansion_button.rect_min_size = Vector2(300,100)
		expansion_button.connect("pressed", self, "_on_expansion_pressed", [expansion_name])
		expansion_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		expansion_picker_container.add_child(expansion_button)		

func _on_expansion_pressed(expansion_name):
	selected_expansion_name = expansion_name
	container.remove_child(expansion_picker_container)
	show_companion()

func show_companion():
	companion_container = Container.new()
	
	container.add_child(companion_container)
	
	var solo_ai = solo_ais[selected_ai_name]	
	solo_ai.texture.set_position(Vector2(750,10))
	companion_container.add_child(solo_ai.texture)
	
	var expansion = expansions[selected_expansion_name]
	var expansion_label = Label.new()
	expansion_label.text = "Expansion: " + expansion.display
	expansion_label.set_position(Vector2(800,10))
	companion_container.add_child(expansion_label)
	
	show_city_plans()
	show_construction_cards()
	
func show_city_plans():
	pass
	
func show_construction_cards():
	var construction_deck = ConstructionDeck.new()
	construction_deck.setup()
	construction_deck.shuffle()
	var top_card = construction_deck.top_card()
	top_card.back_texture.set_position(Vector2(100,60))
	top_card.show_back()
	companion_container.add_child(top_card)
	var count_label = construction_deck.count_label()
	count_label.set_position(Vector2(100,10))
	companion_container.add_child(count_label)

	
	
