extends Node

var hidden_button_style = null

static func build():
	var button = Button.new()
	if SC.Static.InvisibleButton.hidden_button_style == null:
		SC.Static.InvisibleButton.hidden_button_style = StyleBoxFlat.new()
		SC.Static.InvisibleButton.hidden_button_style.bg_color = Color(0,0,0,0)
	button.add_stylebox_override("normal", SC.Static.InvisibleButton.hidden_button_style)
	button.add_stylebox_override("hover", SC.Static.InvisibleButton.hidden_button_style)
	button.add_stylebox_override("focus", SC.Static.InvisibleButton.hidden_button_style)
	button.add_stylebox_override("pressed", SC.Static.InvisibleButton.hidden_button_style)
	button.add_stylebox_override("disabled", SC.Static.InvisibleButton.hidden_button_style)
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	return button
