extends Node

var GameData = SC.Assets.game_data()

var container

var decks = {}

func _ready():
	container = SC.get_container()
	setup_decks()

func setup_decks():
	for deck_name in GameData.decks:
		var deck_info = GameData.decks[deck_name]
		deck_info.card_size_pixels = GameData.card_size_pixels
		var front = SC.Assets.load(deck_info.front)
		var back = SC.Assets.load(deck_info.back)
		var card_book = SC.Instance.CardBook.new(front, deck_info, deck_info.index_range)
		decks[deck_name] = card_book.get_deck()
		decks[deck_name].set_back(back)
	debug_cards()

func debug_cards():
	#SC.link(container, decks.fate.build_picker())
	SC.link(container, decks.player.build_picker())
