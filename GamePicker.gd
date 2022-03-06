extends Node

var games = [
	"Hadrians Wall",
	"Marvel United",
	"To the Death",
	"Welcome To"
]

func _ready():
	SC.reset()

	var game_picker_container = SC.Statics.CenteredContainer().build()
	SC.link(self, game_picker_container)

	var game_grid = SC.Statics.MarginGridContainer.build(6)

	for game in games:
		var game_button = SC.Statics.TextButton.build(self, game, "_on_game_chosen", [game])
		SC.link(game_grid,game_button)

	var fullscreen_button = SC.Statics.TextButton.build(self, "Fullscreen", "_on_fullscreen_pressed", [])

	var vbox = VBoxContainer.new()
	vbox.set("custom_constants/separation", 100)
	SC.link(vbox, game_grid)
	SC.link(vbox, fullscreen_button)
	SC.link(game_picker_container,vbox)

func _on_game_chosen(game):
	SC.Assets.set_companion_name(game)
	return get_tree().change_scene("res://companion/" + game + "/" + game + ".tscn")

func _on_fullscreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
