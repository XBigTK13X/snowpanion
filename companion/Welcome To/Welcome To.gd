extends Node

var ConstructionDeck = load('res://companion/Welcome To/instance/construction-deck.gd')
var PlanDecks = load('res://companion/Welcome To/instance/plan-decks.gd')
var AIScore = load('res://companion/Welcome To/instance/ai-score.gd')

var GameData = SC.Assets.game_data("Welcome To")

var container
var ai_picker_container
var expansion_picker_container
var plan_picker_container
var companion_container
var game_area_container
var chosen_plans_container
var player_temp_container
var player_temp_count_label
var scoring_container


var chosen_plan_cards = []
var selected_ai_name
var selected_expansion_name
var plan_decks
var first_plan_validated = false
var first_player_plan_completed = false
var player_temp_count

var construction_deck
var ai_deck
var discard_deck
var ai_completed_plans = []

var turn_states = []

func _ready():
	container = get_node("/root/Container")
	show_ai_picker()

func show_ai_picker():
	var ai_sheet_data = {
		card_sheet_columns = 3,
		card_sheet_rows = 3,
		card_size_pixels = Vector2(210, 320),
		card_margins = Vector2(7,12)
	}
	var ai_deck_front = SC.Instance.CardBook.new([SC.Assets.load("Welcome To", "front-solo.jpg")], ai_sheet_data).get_deck()
	var ai_deck_back = SC.Instance.CardBook.new([SC.Assets.load("Welcome To", "back-solo.jpg")], ai_sheet_data).get_deck()

	ai_picker_container = SC.Chrome.center_container()
	SC.link(container,ai_picker_container)

	var ai_grid = SC.Chrome.margin_grid_container(5)

	for solo_ai_name in GameData.solo_ais:
		var solo_ai = GameData.solo_ais[solo_ai_name]
		var ai_picker_deck = ai_deck_front
		if solo_ai.asset == "back":
			ai_picker_deck = ai_deck_back
		GameData.solo_ais[solo_ai_name].card = ai_picker_deck.get_card(solo_ai.atlas_index)
		GameData.solo_ais[solo_ai_name].name = solo_ai_name
		var ai_button = GameData.solo_ais[solo_ai_name].card.get_back_button()
		ai_button.connect("pressed", self, "_on_solo_ai_pressed", [solo_ai_name])
		SC.link(ai_grid, ai_button)

	SC.link(ai_picker_container,ai_grid)

func _on_solo_ai_pressed(solo_ai_name):
	selected_ai_name = solo_ai_name
	SC.clean(ai_picker_container)
	show_expansion_picker()

func show_expansion_picker():
	expansion_picker_container = SC.Chrome.center_container()
	SC.link(container,expansion_picker_container)

	var expansion_grid = SC.Chrome.margin_grid_container(3)

	for expansion_name in GameData.expansions:
		var expansion = GameData.expansions[expansion_name]
		if ! expansion.supported:
			continue
		var expansion_button = SC.Chrome.text_button(self, expansion.display, "_on_expansion_pressed", [expansion_name])
		SC.link(expansion_grid,expansion_button)

	SC.link(expansion_picker_container,expansion_grid)

func _on_expansion_pressed(expansion_name):
	SC.clean(expansion_picker_container)
	selected_expansion_name = expansion_name
	plan_decks = PlanDecks.new()
	show_plan_picker()

func show_plan_picker(plan_index=0):
	SC.clean(plan_picker_container)
	plan_picker_container = SC.Chrome.center_container()

	var grid_container = SC.Chrome.margin_grid_container(6)

	var plan_deck = plan_decks.get_deck(plan_index)
	for card in plan_deck.get_all_cards():
		var card_button = SC.Chrome.highlight_on_hover_button(card.front_texture.texture)
		card_button.connect("pressed", self, "_on_plan_chosen", [card])
		SC.link(grid_container, card_button)

	SC.link(plan_picker_container, grid_container)
	SC.link(container, plan_picker_container)

func _on_plan_chosen(plan_card):
	chosen_plan_cards.push_back(plan_card)
	if(plan_card.get_plan().tier < 3):
		show_plan_picker(plan_card.get_plan().tier)
	else:
		show_companion()

func show_companion():
	SC.clean(plan_picker_container)
	companion_container = Container.new()
	SC.link(container,companion_container)

	show_construction_cards()

func show_construction_cards():
	construction_deck = ConstructionDeck.new()
	ai_deck = ConstructionDeck.new()
	discard_deck = ConstructionDeck.new()
	construction_deck.setup()

	update_game_area()

func draw_construction_card():
	var card = construction_deck.draw_top()
	if card == null:
		construction_deck.add_all(discard_deck)
		discard_deck.clear()
		construction_deck.shuffle()
		card = construction_deck.draw_top()
	if card.is_plan():
		var plan_card = chosen_plan_cards[card.get_tier()]
		ai_completed_plans.push_back({card=card, max_score=plan_card.get_score(), plan_card=plan_card})
		return draw_construction_card()
	return card

func update_game_area():
	var solo_ai = GameData.solo_ais[selected_ai_name]
	SC.clean(game_area_container)

	var expansion = GameData.expansions[selected_expansion_name]
	var expansion_label = SC.Chrome.label("Expansion: " + expansion.display)
	var pick_label = SC.Chrome.label("Select a card to give to the AI")
	var count_label = construction_deck.count_label()
	var discard_label = discard_deck.count_label()
	var ai_count_label = ai_deck.count_label()

	if(!first_plan_validated and first_player_plan_completed):
		return handle_first_plan_validation()

	if(!first_plan_validated and ai_completed_plans.size() > 0):
		return handle_first_plan_validation()

	if construction_deck.size() + discard_deck.size() < 3:
		return end_game()

	if ai_completed_plans.size() >= 3:
		return end_game()

	var choices_container = SC.Chrome.margin_grid_container(3)
	var first_card = draw_construction_card()
	var second_card = draw_construction_card()
	var third_card = draw_construction_card()

	var first_front_button = SC.Chrome.highlight_on_hover_button(first_card.front_texture.texture)
	first_front_button.connect("pressed", self, "_on_choose_offer", [first_card,[second_card,third_card]])
	var second_front_button = SC.Chrome.highlight_on_hover_button(second_card.front_texture.texture)
	second_front_button.connect("pressed", self, "_on_choose_offer", [second_card,[first_card,third_card]])
	var third_front_button = SC.Chrome.highlight_on_hover_button(third_card.front_texture.texture)
	third_front_button.connect("pressed", self, "_on_choose_offer", [third_card,[first_card,second_card]])
	var first_back_button = SC.Chrome.highlight_on_hover_button(first_card.back_texture.texture)
	first_back_button.connect("pressed", self, "_on_choose_offer", [first_card,[second_card,third_card]])
	var second_back_button = SC.Chrome.highlight_on_hover_button(second_card.back_texture.texture)
	second_back_button.connect("pressed", self, "_on_choose_offer", [second_card,[first_card,third_card]])
	var third_back_button = SC.Chrome.highlight_on_hover_button(third_card.back_texture.texture)
	third_back_button.connect("pressed", self, "_on_choose_offer", [third_card,[first_card,second_card]])

	var top_card = construction_deck.top_card()
	if top_card == null:
		construction_deck.add_all(discard_deck)
		discard_deck.clear()
		construction_deck.shuffle()
		top_card = construction_deck.top_card()
	var end_game_button = SC.Chrome.text_button(self, "End Game", "_prompt_end_game", [])
	end_game_button.rect_min_size = Vector2(200,100)
	end_game_button.set_h_size_flags(Container.SIZE_FILL)
	end_game_button.set_v_size_flags(Container.SIZE_FILL)
	end_game_button.anchor_top = 0.5
	end_game_button.anchor_bottom = 0.5

	var top_ai_card = ai_deck.top_card()

	var claimed_plans_container = VBoxContainer.new()
	for plan in ai_completed_plans:
		SC.link(claimed_plans_container, plan.card.front_texture)

	update_chosen_plans()

	game_area_container = SC.Chrome.center_container()
	var first_row = HBoxContainer.new()
	first_row.set("custom_constants/separation", 100)
	var first_column = VBoxContainer.new()
	first_column.set_alignment(BoxContainer.ALIGN_CENTER)
	first_column.set("custom_constants/separation", 50)
	var second_column = VBoxContainer.new()
	second_column.set_alignment(BoxContainer.ALIGN_CENTER)
	var third_column = VBoxContainer.new()
	third_column.set_alignment(BoxContainer.ALIGN_CENTER)
	third_column.set("custom_constants/separation", 50)
	var fourth_column = VBoxContainer.new()
	fourth_column.set_alignment(BoxContainer.ALIGN_CENTER)
	fourth_column.set("custom_constants/separation", 50)

	count_label.text = count_label.text + ' in Deck'
	discard_label.text = discard_label.text + ' Discarded'

	SC.link(choices_container,[
		first_front_button,second_front_button,third_front_button,first_back_button,second_back_button,third_back_button
	])

	SC.link(first_column, [count_label, top_card.back_texture, discard_label, end_game_button])
	SC.link(second_column, [pick_label, choices_container, chosen_plans_container])
	SC.link(third_column, [expansion_label, solo_ai.card.get_front()])
	SC.link(fourth_column, claimed_plans_container)

	if top_ai_card != null:
		ai_count_label.text = ai_count_label.text + ' Taken'
		SC.link(third_column,[top_ai_card.back_texture, ai_count_label])

	SC.link(first_row, [first_column, second_column, third_column, fourth_column])
	SC.link(game_area_container, first_row)
	SC.link(companion_container, game_area_container)

	if(GameData.debug_ai_scoring):
		_on_choose_offer(first_card, [second_card, third_card])

func _prompt_end_game():
	var confirm = ConfirmationDialog.new()
	confirm.rect_min_size = Vector2(400,200)
	confirm.get_ok().rect_min_size = Vector2(200,100)
	confirm.anchor_left = 0.4
	confirm.anchor_top = 0.4
	confirm.dialog_text = "Are you ready to end the game?"
	confirm.window_title = "Are you sure?"
	confirm.connect("confirmed", self, "end_game")
	confirm.popup_exclusive = true
	container.add_child(confirm)
	confirm.popup()

func end_game():
	show_player_temp()

func update_chosen_plans():
	if(chosen_plans_container == null):
		chosen_plans_container = HBoxContainer.new()
		chosen_plans_container.set("custom_constants/separation", 20)
	else:
		SC.remove_children(chosen_plans_container)
	var all_plans_completed = true
	for plan in chosen_plan_cards:
		var button_texture = plan.front_texture.texture
		if plan.is_completed():
			button_texture = plan.back_texture.texture
		else:
			all_plans_completed = false
		var plan_button = SC.Chrome.highlight_on_hover_button(button_texture)
		plan_button.connect("pressed", self, "_on_plan_pressed", [plan])
		chosen_plans_container.add_child(plan_button)
	if(all_plans_completed):
		end_game()

func handle_first_plan_validation():
	if(!first_plan_validated):
		construction_deck.add_all(discard_deck)
		discard_deck.clear()
		construction_deck.shuffle()
		first_plan_validated = true
		update_game_area()

func _on_plan_pressed(plan_card):
	plan_card.toggle()
	if(!first_plan_validated):
		first_player_plan_completed = plan_card.is_completed()
	update_chosen_plans()

func _on_choose_offer(pick, discards):
	ai_deck.put_on_top(pick)
	discard_deck.put_on_top(discards.pop_back())
	discard_deck.put_on_top(discards.pop_back())
	for plan in ai_completed_plans:
		if(!plan.plan_card.is_completed()):
			plan.plan_card.toggle()
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

	var label = SC.Chrome.label("How many temp agency cards were used by the player?")
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
	scored_cards_container.set_columns(8)
	var scored_cards = ai_deck.get_all_cards()
	for card in scored_cards:
		# FIXME This is the only way I could get the textures to "scale" and stay within the bounds of the viewport
		card.back_texture.expand = true
		card.back_texture.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT)
		# 50% of base texture dimensions (210,320)
		card.back_texture.rect_min_size = Vector2(105,160)
		SC.link(scored_cards_container,card.back_texture)

	var ai_score = AIScore.new(GameData.solo_ais[selected_ai_name], GameData.expansions[selected_expansion_name], ai_completed_plans, scored_cards, player_temp_count)
	ai_score.calculate()
	var ai_score_label = SC.Chrome.label(ai_score.format_breakdown())

	var solo_ai = GameData.solo_ais[selected_ai_name]

	var claimed_plans_container = HBoxContainer.new()
	for plan in ai_completed_plans:
		plan.card.front_texture.expand = true
		plan.card.front_texture.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT)
		plan.card.front_texture.rect_min_size = Vector2(105,160)
		plan.plan_card.front_texture.expand = true
		plan.plan_card.front_texture.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT)
		plan.plan_card.front_texture.rect_min_size = Vector2(105,160)
		SC.link(claimed_plans_container, plan.card.front_texture)
		SC.link(claimed_plans_container, plan.plan_card.front_texture)

	var close_companion_button = SC.Chrome.text_button(self, "Close Companion", "close_companion", [])
	close_companion_button.set_h_size_flags(Container.SIZE_FILL)
	close_companion_button.set_v_size_flags(Container.SIZE_FILL)
	close_companion_button.rect_min_size = Vector2(200,100)

	var hbox = HBoxContainer.new()
	hbox.set("custom_constants/separation", 100)
	var first_column = VBoxContainer.new()
	var second_column = VBoxContainer.new()
	var third_column = VBoxContainer.new()
	second_column.set("custom_constants/separation", 100)
	SC.link(hbox,first_column)
	SC.link(hbox,second_column)
	SC.link(hbox, third_column)
	SC.link(first_column,solo_ai.card.get_front())
	SC.link(first_column,ai_score_label)
	SC.link(second_column, scored_cards_container)
	SC.link(second_column, claimed_plans_container)
	SC.link(third_column, close_companion_button)
	SC.link(scoring_container, hbox)
	SC.link(container,scoring_container)

func close_companion():
	SC.Scenes.close_companion()


