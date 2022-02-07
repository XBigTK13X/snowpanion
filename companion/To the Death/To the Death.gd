extends Node

var GameData = SC.Assets.game_data("To the Death")

var decks = {
	monsters = []
}

func _ready():
	setup_decks()

func setup_decks():
	for deck_name in GameData.decks:
		var deck_info = GameData.decks[deck_name]
		for asset_index in range(deck_info.asset_range[0],deck_info.asset_range[1]):
			var asset_name = deck_info.asset_dir+'/output-'+str(asset_index)+'.jpg'
			if(asset_index < 10):
				asset_name = deck_info.asset_dir+'/output-0'+str(asset_index)+'.jpg'
			var asset = SC.Assets.load('To the Death', asset_name)
			var card_sheet = SC.Instance.CardSheet.new(asset, GameData.card_sheet_columns, GameData.card_sheet_rows)
			decks[deck_name] = decks[deck_name] + card_sheet.get_all()
	
