extends Node

var ConstructionCard = load('res://companion/Welcome To/instance/construction-card.gd')
var SoloPlanCard = load('res://companion/Welcome To/instance/solo-plan-card.gd')

# The 0th element in the deck is the top. The size-th element is the bottom.

var GameData = SC.Assets.game_data("Welcome To")

var deck_cards = []

func setup():
	for kind in GameData.constructions:			
		for number_index in GameData.constructions[kind].size():
			var card = ConstructionCard.new(kind, GameData.constructions[kind][number_index], number_index)
			deck_cards.push_back(card)
	shuffle()
	var n1_solo_plan = SoloPlanCard.new("n1", 0, 5) 
	var n1_insert_index = SC.RNG.integer(ceil(deck_cards.size()/2),deck_cards.size() - 1)
	deck_cards.insert(n1_insert_index, n1_solo_plan)
	var n2_solo_plan = SoloPlanCard.new("n2", 1, 8) 
	var n2_insert_index = SC.RNG.integer(ceil(deck_cards.size()/2),deck_cards.size() - 1)
	deck_cards.insert(n2_insert_index, n2_solo_plan)
	var n3_solo_plan = SoloPlanCard.new("n3", 2, 7) 
	var n3_insert_index = SC.RNG.integer(ceil(deck_cards.size()/2),deck_cards.size() - 1)
	deck_cards.insert(n3_insert_index, n3_solo_plan)

func shuffle():
	deck_cards.shuffle()

func top_card():
	if deck_cards.size() > 0:
		return deck_cards[0]
	else:
		return null

func put_on_top(card):
	deck_cards.push_front(card)

func count_label():
	var label = SC.Chrome.label('')
	if(deck_cards.size() == 1):
		label.text = str(deck_cards.size()) + " Card"
	else:
		label.text = str(deck_cards.size()) + " Cards"
	return label

func draw_top():
	if deck_cards.size() <= 0:
		return null
	var draw = deck_cards.pop_front()
	return draw


func add_all(deck):
	deck_cards += deck.deck_cards

func clear():
	deck_cards = []

func size():
	return deck_cards.size()

func get_all_cards():
	return deck_cards
