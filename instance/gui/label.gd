extends Node

static func build(text):
	var label = Label.new()
	label.set('custom_fonts/font', SC.Assets.get_font('Text Label'))
	label.text = text
	return label