extends Node

var ConstructionCard = load('res://companion/Welcome To/instance/construction-card.gd')
var PlanCard = load('res://companion/Welcome To/instance/plan-card.gd')

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

var _count_label = Label.new()

func setup():
	for kind in card_numbers:			
		for number_index in card_numbers[kind].size():
			var card = ConstructionCard.new()
			card.init(kind, card_numbers[kind][number_index], number_index)
			deck_cards.push_back(card)
	_count_label.text = str(deck_cards.size()) + " Cards"

func shuffle():
	deck_cards.shuffle()

func top_card():
	return deck_cards[0]

func add_card(card):
	deck_cards.push_back(card)

func count_label():
	return _count_label
