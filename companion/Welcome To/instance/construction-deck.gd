extends Node

var ConstructionCard = load('res://companion/Welcome To/instance/construction-card.gd')
var SoloPlanCard = load('res://companion/Welcome To/instance/solo-plan-card.gd')
var PlanCard = load('res://companion/Welcome To/instance/plan-card.gd')

# The 0th element in the deck is the top. The size-th element is the bottom.

var card_numbers = {
	fence = [1,2,3,5,5,6,6,7,8,8,9,10,10,11,11,13,14,15],
	temp = [3,4,6,7,8,9,10,12,13],
	pool = [3,4,6,7,8,9,10,12,13],
	estate = [1,2,4,5,5,6,7,7,8,8,9,9,10,11,11,12,14,15],
	bis = [3,4,6,7,8,9,10,12,13],
	park = [1,2,4,5,5,6,7,7,8,8,9,9,10,11,11,12,14,15],
}

var objective_cards = ['n1','n2','n3']

var deck_cards = []

var _count_label = SC.Chrome.label('')

func setup():
	for kind in card_numbers:			
		for number_index in card_numbers[kind].size():
			var card = ConstructionCard.new()
			card.init(kind, card_numbers[kind][number_index], number_index)
			deck_cards.push_back(card)
	var n1_solo_plan = SoloPlanCard.new() 
	var n1_insert_index = SC.RNG.integer(ceil(deck_cards.size()/2),deck_cards.size() - 1)
	n1_solo_plan.init("n1", 5)
	deck_cards.insert(n1_insert_index, n1_solo_plan)
	var n2_solo_plan = SoloPlanCard.new() 
	n2_solo_plan.init("n2", 8)
	var n2_insert_index = SC.RNG.integer(ceil(deck_cards.size()/2),deck_cards.size() - 1)
	deck_cards.insert(n2_insert_index, n2_solo_plan)
	var n3_solo_plan = SoloPlanCard.new() 
	n3_solo_plan.init("n3", 7)
	var n3_insert_index = SC.RNG.integer(ceil(deck_cards.size()/2),deck_cards.size() - 1)
	deck_cards.insert(n3_insert_index, n3_solo_plan)
	_update_deck_count()

func _update_deck_count():
	_count_label.text = str(deck_cards.size()) + " Cards"

func shuffle():
	deck_cards.shuffle()

func top_card():
	if deck_cards.size() > 0:
		return deck_cards[0]
	else:
		return null

func put_on_top(card):
	deck_cards.push_front(card)
	_update_deck_count()

func count_label():
	return _count_label

func draw_top():
	if deck_cards.size() <= 0:
		return null
	var draw = deck_cards.pop_front()
	_update_deck_count()
	return draw


func add_all(deck):
	deck_cards += deck.deck_cards
	_update_deck_count()

func clear():
	deck_cards = []
	_update_deck_count()

func size():
	return deck_cards.size()

func get_all_cards():
	return deck_cards
