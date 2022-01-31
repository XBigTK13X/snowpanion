extends Node

var games = [
	"Welcome To"
]

func _ready():
	SC.reset()

	var game_picker_container = SC.Chrome.center_container()
	add_child(game_picker_container)
	
	var game_grid = GridContainer.new()
	game_grid.set_columns(6)	

	for game in games:	
		var game_button = SC.Chrome.text_button(self, game, "_on_game_chosen", [game])
		game_grid.add_child(game_button)		
		
	game_picker_container.add_child(game_grid)

func _on_game_chosen(game):
	return get_tree().change_scene("res://companion/" + game + "/" + game + ".tscn")
