extends Node

func get(script):
	return load('res://instance/'+script+'.gd')

# Card
var Card = get('card/card')
var CardBook = get('card/card-book')
var CardSheet = get('card/card-sheet')
var Deck = get('card/deck')

# GUI
var ItemPicker = get('gui/item-picker')
var ItemMultiPicker = get('gui/item-multi-picker')