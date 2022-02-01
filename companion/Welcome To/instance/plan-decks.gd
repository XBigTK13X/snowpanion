extends Node

var PlanDeck = load('res://companion/Welcome To/instance/plan-deck.gd')

var _decks

func _init():
	_decks = [
		PlanDeck.new('base', 1),
		PlanDeck.new('base', 2),
		PlanDeck.new('base', 3)
	]

func get_deck(plan_index):
	return _decks[plan_index]