extends Node

func get(script):
	return load('res://instance/'+script+'.gd')

var Card = get('card')
var CardBook = get('card-book')
var CardSheet = get('card-sheet')
var Deck = get('deck')
