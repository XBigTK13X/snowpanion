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
		var game_button = Button.new()
		game_button.text = game
		game_button.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		game_button.set_v_size_flags(Control.SIZE_EXPAND_FILL)
		game_button.rect_min_size = Vector2(400,200)
		game_button.connect("pressed", self, "_on_game_chosen", [game])
		game_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		game_grid.add_child(game_button)		
		
	game_picker_container.add_child(game_grid)

func _on_game_chosen(game):
	return get_tree().change_scene("res://companion/" + game + "/" + game + ".tscn")
