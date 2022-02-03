extends Node

var _plan
var _completed = false

var front_texture
var back_texture

func _init(expansion, plan):    
	_plan = plan

	front_texture = get_texture(expansion, 'front', plan.atlas_index)
	back_texture = get_texture(expansion, 'back', plan.atlas_index)

func get_texture(expansion, kind, index):
	var textures = SC.Assets.load("Welcome To", expansion + "-objective-" + kind + ".jpg")
	var atlas_texture = AtlasTexture.new()
	atlas_texture.set_atlas(textures)
	var texture_column = (index % 7)
	var texture_row = (index / 7)    
	var card_width = 225.42
	var card_height = 343.4
	var clip_margin = Vector2(5,5)
	atlas_texture.set_region(Rect2((texture_column * card_width) + clip_margin.x + _plan.nudge.x,(texture_row * card_height) + clip_margin.y + _plan.nudge.y, card_width - (clip_margin.x * 2), card_height - (clip_margin.y * 2)))
	atlas_texture.set_filter_clip(true)
	var texture = TextureRect.new()
	texture.texture = atlas_texture
	return texture

func toggle():
	_completed = !_completed

func is_completed():
	return _completed

func get_plan():
	return _plan

func get_score():
	if(_completed):
		return _plan.min
	return _plan.max
