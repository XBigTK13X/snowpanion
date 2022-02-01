extends Node

var ConstructionDeck = load('res://companion/Welcome To/instance/construction-deck.gd')
var AIScore = load('res://companion/Welcome To/instance/ai-score.gd')

var container
var ai_picker_container
var expansion_picker_container
var companion_container
var game_area_container
var player_temp_container
var player_temp_count_label
var scoring_container


var selected_ai_name
var selected_expansion_name
var player_temp_count

var construction_deck
var ai_deck
var discard_deck
var ai_completed_plans = []

var turn_states = []

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
	none = {display="None", bonus_points=0, supported=true},
	halloween = {display="Halloween", bonus_points=15, supported=true},	
	doomsday = {display="Nuclear Doomsday", bonus_points=0, supported=false},		
	spring = {display="Spring / Easter", bonus_points=20, supported=true},
	summer = {display="Summer Ice Cream", bonus_points=25, supported=true},
	winter = {display="Winter Wonderland", bonus_points=25, supported=true},
	outbreak = {display="Zombie Outbreak", bonus_points=0, supported=false}
}

func _ready():	
	container = get_node("/root/Container")
	show_ai_picker()
	
func show_ai_picker():
	var front_texture = SC.Assets.load("Welcome To", "front-solo.jpg")
	var back_texture = SC.Assets.load("Welcome To", "back-solo.jpg")
	
	ai_picker_container = SC.Chrome.center_container()
	SC.link(container,ai_picker_container)

	var ai_grid = GridContainer.new()
	ai_grid.set_columns(5)
	
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
		solo_ais[solo_ai_name].texture = TextureRect.new()
		solo_ais[solo_ai_name].texture.texture = atlas_texture
		solo_ais[solo_ai_name].name = solo_ai_name
		var ai_button = SC.Chrome.highlight_on_hover_button(atlas_texture)
		ai_button.connect("pressed", self, "_on_solo_ai_pressed", [solo_ai_name])
		SC.link(ai_grid,ai_button)
	
	SC.link(ai_picker_container,ai_grid)
	
func _on_solo_ai_pressed(solo_ai_name):
	selected_ai_name = solo_ai_name
	SC.clean(ai_picker_container)
	show_expansion_picker()

func show_expansion_picker():
	expansion_picker_container = SC.Chrome.center_container()
	SC.link(container,expansion_picker_container)

	var expansion_grid = GridContainer.new()
	expansion_grid.set_columns(3)	

	for expansion_name in expansions:
		var expansion = expansions[expansion_name]
		if ! expansion.supported:
			continue
		var expansion_button = SC.Chrome.text_button(self, expansion.display, "_on_expansion_pressed", [expansion_name])
		SC.link(expansion_grid,expansion_button)		
	
	SC.link(expansion_picker_container,expansion_grid)

func _on_expansion_pressed(expansion_name):
	selected_expansion_name = expansion_name	
	show_companion()

func show_companion():
	SC.clean(expansion_picker_container)
	companion_container = Container.new()	
	SC.link(container,companion_container)	
	
	show_city_plans()
	show_construction_cards()
	
func show_city_plans():
	pass
	
func show_construction_cards():
	construction_deck = ConstructionDeck.new()
	ai_deck = ConstructionDeck.new()
	discard_deck = ConstructionDeck.new()
	construction_deck.setup()
	construction_deck.shuffle()
	
	update_game_area()

func draw_construction_card():
	var card = construction_deck.draw_top()
	if card == null:
		construction_deck.add_all(discard_deck)
		discard_deck.clear()
		construction_deck.shuffle()
		card = construction_deck.draw_top()
	if card.is_plan():		
		ai_completed_plans.push_back(card)
		return draw_construction_card()
	return card

func update_game_area():
	var solo_ai = solo_ais[selected_ai_name]	
	if game_area_container != null:
		SC.clean(game_area_container)
		
	game_area_container = SC.Chrome.center_container()
	var hbox = HBoxContainer.new()
	var first_column = VBoxContainer.new()
	var second_column = VBoxContainer.new()
	var third_column = VBoxContainer.new()
		
	var expansion = expansions[selected_expansion_name]
	var expansion_label = SC.Chrome.label("Expansion: " + expansion.display)
	var pick_label = SC.Chrome.label("Select a card to give to the AI")	
	var count_label = construction_deck.count_label()		
	var ai_count_label = ai_deck.count_label()	

	if construction_deck.size() + discard_deck.size() < 3:
		show_player_temp()
		return
		
	var choices_container = GridContainer.new()
	choices_container.set_columns(3)
	var first_card = draw_construction_card()
	var second_card = draw_construction_card()
	var third_card = draw_construction_card()
	
	
	if ai_completed_plans.size() >= 3:
		show_player_temp()
		return
		
	var first_front_button = SC.Chrome.highlight_on_hover_button(first_card.front_texture.texture)
	first_front_button.connect("pressed", self, "_on_choose_offer", [first_card,[second_card,third_card]])
	SC.link(choices_container,first_front_button)
	var second_front_button = SC.Chrome.highlight_on_hover_button(second_card.front_texture.texture)
	second_front_button.connect("pressed", self, "_on_choose_offer", [second_card,[first_card,third_card]])
	SC.link(choices_container,second_front_button)
	var third_front_button = SC.Chrome.highlight_on_hover_button(third_card.front_texture.texture)
	third_front_button.connect("pressed", self, "_on_choose_offer", [third_card,[first_card,second_card]])
	SC.link(choices_container,third_front_button)
	var first_back_button = SC.Chrome.highlight_on_hover_button(first_card.back_texture.texture)
	first_back_button.connect("pressed", self, "_on_choose_offer", [first_card,[second_card,third_card]])
	SC.link(choices_container,first_back_button)
	var second_back_button = SC.Chrome.highlight_on_hover_button(second_card.back_texture.texture)
	second_back_button.connect("pressed", self, "_on_choose_offer", [second_card,[first_card,third_card]])
	SC.link(choices_container,second_back_button)
	var third_back_button = SC.Chrome.highlight_on_hover_button(third_card.back_texture.texture)
	third_back_button.connect("pressed", self, "_on_choose_offer", [third_card,[first_card,second_card]])
	SC.link(choices_container,third_back_button)	
	
	var top_card = construction_deck.top_card()
	if top_card == null:
		construction_deck.add_all(discard_deck)
		discard_deck.clear()
		construction_deck.shuffle()
		top_card = construction_deck.top_card()	
	
	var top_ai_card = ai_deck.top_card()	
	
	SC.link(first_column,top_card.back_texture)
	SC.link(first_column,count_label)
	SC.link(second_column,pick_label)
	SC.link(second_column,choices_container)		
	SC.link(third_column,expansion_label)
	SC.link(third_column,solo_ai.texture)		

	if top_ai_card != null:
		SC.link(third_column,top_ai_card.back_texture)

	SC.link(third_column,ai_count_label)

	hbox.set("custom_constants/separation", 100)

	SC.link(hbox,first_column)
	SC.link(hbox,second_column)
	SC.link(hbox,third_column)
	SC.link(game_area_container,hbox)	
	SC.link(companion_container,game_area_container)		


func _on_choose_offer(pick, discards):
	ai_deck.put_on_top(pick)
	discard_deck.put_on_top(discards.pop_back())
	discard_deck.put_on_top(discards.pop_back())
	update_game_area()
	
func show_player_temp():
	SC.clean(companion_container)
	player_temp_container = SC.Chrome.center_container()

	var box = VBoxContainer.new()

	var grid = GridContainer.new()
	grid.set_columns(5)

	for ii in range(0,25):
		var player_temp_button = SC.Chrome.text_button(self, str(ii), "_on_player_temp_click", [ii])
		player_temp_button.rect_min_size = Vector2(200,100)
		SC.link(grid,player_temp_button)
	
	var label = SC.Chrome.label("How many temp agencies were used by the player?")
	SC.link(box,label)	
	SC.link(box,grid)
	SC.link(player_temp_container,box)
	SC.link(container,player_temp_container)

func _on_player_temp_click(amount):
	player_temp_count = amount
	show_ai_score()

func show_ai_score():
	SC.clean(player_temp_container)	
	scoring_container = SC.Chrome.center_container()
	
	var scored_cards_container = GridContainer.new()
	scored_cards_container.set_columns(6)

	var scored_cards = ai_deck.get_all_cards()
	# TODO Put inside a scroll container
	for card in scored_cards:
		SC.link(scored_cards_container,card.back_texture)
	
	var ai_score = AIScore.new()
	ai_score.init(solo_ais[selected_ai_name], expansions[selected_expansion_name], [], scored_cards, player_temp_count)
	ai_score.calculate()
	var ai_score_label = SC.Chrome.label(ai_score.format_breakdown())

	var solo_ai = solo_ais[selected_ai_name]

	var hbox = HBoxContainer.new()
	var vbox = VBoxContainer.new()
	SC.link(hbox,vbox)
	SC.link(vbox,solo_ai.texture)
	SC.link(vbox,ai_score_label)
	SC.link(hbox,vbox)
	SC.link(hbox,scored_cards_container)
	SC.link(scoring_container,hbox)

	SC.link(container,scoring_container)


	
