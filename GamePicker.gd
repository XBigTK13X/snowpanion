extends Node

var games = [
	"Welcome To"
]

func _ready():
	SC.reset()

	var game_picker_container = SC.Chrome.center_container()
	SC.link(self, game_picker_container)
	
	var game_grid = GridContainer.new()
	game_grid.set_columns(6)	

	for game in games:	
		var game_button = SC.Chrome.text_button(self, game, "_on_game_chosen", [game])
		SC.link(game_grid,game_button)		
		
	var fullscreen_button = SC.Chrome.text_button(self, "Fullscreen", "_on_fullscreen_pressed", [])
		
	var vbox = VBoxContainer.new()
	vbox.set("custom_constants/separation", 100)
	SC.link(vbox, game_grid)
	SC.link(vbox, fullscreen_button)
	SC.link(game_picker_container,vbox)

func _on_game_chosen(game):
	return get_tree().change_scene("res://companion/" + game + "/" + game + ".tscn")

func _on_fullscreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
