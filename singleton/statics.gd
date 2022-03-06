extends Node

static func get(script):
	return load('res://static/'+script+'.gd')

# GUI
static func CenteredContainer():
	return get('gui/centered-container')
static func HighlightButton():
	return get('gui/highlight-button')
static func InvisibleButton():
	return get('gui/invisible-button')
static func TextLabel():
	return get('gui/text-label')
static func MarginGridContainer():
	return get('gui/margin-grid-container')
static func TextButton():
	return get('gui/text-button')
static func TexturedButton():
	return get('gui/textured-button')
