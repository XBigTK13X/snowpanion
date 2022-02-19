extends Node

var hidden_button_style = null

static func build():
	var button = Button.new()
	if SC.Instance.InvisibleButton.hidden_button_style == null:
		SC.Instance.InvisibleButton.hidden_button_style = StyleBoxFlat.new()
		SC.Instance.InvisibleButton.hidden_button_style.bg_color = Color(0,0,0,0)
	button.add_stylebox_override("normal", SC.Instance.InvisibleButton.hidden_button_style)
	button.add_stylebox_override("hover", SC.Instance.InvisibleButton.hidden_button_style)
	button.add_stylebox_override("focus", SC.Instance.InvisibleButton.hidden_button_style)
	button.add_stylebox_override("pressed", SC.Instance.InvisibleButton.hidden_button_style)
	button.add_stylebox_override("disabled", SC.Instance.InvisibleButton.hidden_button_style)
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	return button
