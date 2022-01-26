extends Node

var ConstructionDeck = load('res://companion/Welcome To/instance/construction-deck.gd')
var AIScore = load('res://companion/Welcome To/instance/ai-score.gd')

var container
var ai_picker_container
var expansion_picker_container
var companion_container
var offering_container
var scoring_container

var selected_ai_name
var selected_expansion_name

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
		if ! expansion.supported:
			continue
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
	solo_ai.texture.set_position(Vector2(1050,10))
	companion_container.add_child(solo_ai.texture)
	
	var expansion = expansions[selected_expansion_name]
	var expansion_label = Label.new()
	expansion_label.text = "Expansion: " + expansion.display
	expansion_label.set_position(Vector2(1100,10))
	companion_container.add_child(expansion_label)
	
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
	
	var pick_label = Label.new()
	pick_label.text = "Select a card to give to the AI"
	pick_label.set_position(Vector2(350,10))
	companion_container.add_child(pick_label)
	
	var count_label = construction_deck.count_label()
	count_label.set_position(Vector2(100,10))
	companion_container.add_child(count_label)
	
	var ai_count_label = ai_deck.count_label()
	ai_count_label.set_position(Vector2(1150, 400))
	companion_container.add_child(ai_count_label)
	
	draw_offering()

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

func draw_offering():
	if offering_container != null:
		SC.Scenes.clean(offering_container)
	offering_container = Node2D.new()
	
	if construction_deck.size() + discard_deck.size() < 3:
		show_ai_score()
		return
		
	var choices_container = GridContainer.new()
	choices_container.set_position(Vector2(350,60))
	choices_container.set_columns(3)
	var first_card = draw_construction_card()
	var second_card = draw_construction_card()
	var third_card = draw_construction_card()
	
	
	if ai_completed_plans.size() >= 3:
		show_ai_score()
		return
		
	var first_front_button = SC.Chrome.highlight_on_hover_button(first_card.front_texture.texture)
	first_front_button.connect("pressed", self, "_on_choose_offer", [first_card,[second_card,third_card]])
	choices_container.add_child(first_front_button)
	var second_front_button = SC.Chrome.highlight_on_hover_button(second_card.front_texture.texture)
	second_front_button.connect("pressed", self, "_on_choose_offer", [second_card,[first_card,third_card]])
	choices_container.add_child(second_front_button)
	var third_front_button = SC.Chrome.highlight_on_hover_button(third_card.front_texture.texture)
	third_front_button.connect("pressed", self, "_on_choose_offer", [third_card,[first_card,second_card]])
	choices_container.add_child(third_front_button)
	var first_back_button = SC.Chrome.highlight_on_hover_button(first_card.back_texture.texture)
	first_back_button.connect("pressed", self, "_on_choose_offer", [first_card,[second_card,third_card]])
	choices_container.add_child(first_back_button)
	var second_back_button = SC.Chrome.highlight_on_hover_button(second_card.back_texture.texture)
	second_back_button.connect("pressed", self, "_on_choose_offer", [second_card,[first_card,third_card]])
	choices_container.add_child(second_back_button)
	var third_back_button = SC.Chrome.highlight_on_hover_button(third_card.back_texture.texture)
	third_back_button.connect("pressed", self, "_on_choose_offer", [third_card,[first_card,second_card]])
	choices_container.add_child(third_back_button)
	offering_container.add_child(choices_container)
	
	var top_card = construction_deck.top_card()
	if top_card == null:
		construction_deck.add_all(discard_deck)
		discard_deck.clear()
		construction_deck.shuffle()
		top_card = construction_deck.top_card()
	top_card.back_texture.set_position(Vector2(100,60))
	offering_container.add_child(top_card.back_texture)
	
	var top_ai_card = ai_deck.top_card()
	if top_ai_card != null:
		top_ai_card.back_texture.set_position(Vector2(1100, 500))
		offering_container.add_child(top_ai_card.back_texture)
	
	companion_container.add_child(offering_container)

func _on_choose_offer(pick, discards):
	ai_deck.put_on_top(pick)
	discard_deck.put_on_top(discards.pop_back())
	discard_deck.put_on_top(discards.pop_back())
	draw_offering()
	
func show_ai_score():
	SC.Scenes.clean(companion_container)
	scoring_container = Container.new()
	
	var scored_cards_container = GridContainer.new()
	scored_cards_container.set_position(Vector2(300,0))
	scored_cards_container.set_columns(6)
	scoring_container.add_child(scored_cards_container)

	var scored_cards = ai_deck.get_all_cards()
	for card in scored_cards:
		scored_cards_container.add_child(card.back_texture)
	
	var ai_score = AIScore.new()
	ai_score.init(solo_ais[selected_ai_name], expansions[selected_expansion_name], [], scored_cards, 0)
	ai_score.calculate()
	var ai_score_label = Label.new()	
	ai_score_label.set_position(Vector2(10,10))
	ai_score_label.text = ai_score.format_breakdown()
	scoring_container.add_child(ai_score_label)

	var solo_ai = solo_ais[selected_ai_name]	
	solo_ai.texture.set_position(Vector2(0,300))
	scoring_container.add_child(solo_ai.texture)

	container.add_child(scoring_container)
	
	