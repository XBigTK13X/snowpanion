extends Node

var GameData = SC.Assets.game_data("To the Death")

var container
var monster_king_picker
var monsters_picker
var chosen_monsters_list

var chosen_monster_king
var chosen_monsters = {}

var decks = {}

func _ready():
	container = get_node("/root/Container")
	setup_decks()

func setup_decks():
	for deck_name in GameData.decks:
		var deck_info = GameData.decks[deck_name]
		var assets = []
		for asset_index in range(deck_info.asset_range[0],deck_info.asset_range[1]+1):
			var asset_name = deck_info.asset_dir+'/output-'+str(asset_index)+'.jpg'
			if(asset_index < 10):
				asset_name = deck_info.asset_dir+'/output-0'+str(asset_index)+'.jpg'
			assets.push_back(SC.Assets.load('To the Death', asset_name))
		var card_book = SC.Instance.CardBook.new(assets, GameData, deck_info.index_range, deck_info.skip_indices)
		decks[deck_name] = card_book.get_deck()

	# Remove the anti-hero. Including it makes the companion implementation more complicated.
	decks.monster_kings.remove(2)

	show_king_picker()

func debug_cards():
	#SC.link(container, decks.monsters.build_picker())
	SC.link(container, decks.monster_kings.build_picker())
	#SC.link(container, decks.hero_damage.build_picker())
	#SC.link(container, decks.enemy_damage.build_picker())
	#SC.link(container, decks.action_reference.build_picker())

func show_king_picker():
	monster_king_picker = decks.monster_kings.build_picker(self, '_on_choose_monster_king')
	SC.link(container, monster_king_picker)

func _on_choose_monster_king(card):
	chosen_monster_king = card
	SC.clean(monster_king_picker)
	choose_monsters()

func choose_monsters():
	monsters_picker = Container.new()
	var vbox = VBoxContainer.new()
	chosen_monsters_list = HBoxContainer.new()
	chosen_monsters_list.set_alignment(BoxContainer.ALIGN_CENTER)
	chosen_monsters_list.rect_min_size = Vector2(0,GameData.card_size_pixel.y)
	var row_two = HBoxContainer.new()
	var card_picker = decks.monsters.build_picker(self, '_on_choose_monster')
	card_picker.rect_min_size = Vector2(1900,GameData.card_size_pixel.y * 2.2)
	SC.link(row_two, card_picker)
	SC.link(vbox, chosen_monsters_list)
	SC.link(vbox, row_two)
	SC.link(monsters_picker, vbox)
	SC.link(container, monsters_picker)

func _on_choose_monster(card):
	var card_id = card.get_instance_id()
	if card_id in chosen_monsters:
		chosen_monsters.erase(card_id)
	else:
		chosen_monsters[card_id] = card
	if chosen_monsters.size() >= 4:
		SC.clean(monsters_picker)
		show_companion()
	else:
		SC.clean(chosen_monsters_list, false)
		for card_key in chosen_monsters:
			var chosen_card = chosen_monsters[card_key]
			var button = chosen_card.get_front_button()
			button.connect('pressed', self, '_on_choose_monster', [chosen_card])
			chosen_monsters_list.add_child(button)

func show_companion():
	pass
