extends Node

func get(script):
	return load('res://static/'+script+'.gd')

# GUI
var CenterContainer = get('gui/center-container')
var HighlightButton = get('gui/highlight-button')
var InvisibleButton = get('gui/invisible-button')
var Label = get('gui/label')
var MarginGridContainer = get('gui/margin-grid-container')
var TextButton = get('gui/text-button')
var TextureButton = get('gui/texture-button')