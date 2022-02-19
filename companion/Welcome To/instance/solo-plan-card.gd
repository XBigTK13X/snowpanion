extends Node

var _name
var _texture_index

var front_texture
var back_texture
var _tier

func _init(name, tier, texture_index):
	_name = name
	_texture_index = texture_index
	_tier = tier

	var cards_texture = SC.Assets.load("front-solo.jpg")

	var atlas_texture = AtlasTexture.new()
	atlas_texture.set_atlas(cards_texture)
	var texture_column = (texture_index % 3)
	var texture_row = (texture_index / 3)
	var card_width = 230.66
	var card_height = 348.66
	var clip_margin = Vector2(10,10)
	atlas_texture.set_region(Rect2((texture_column * card_width) + clip_margin.x,(texture_row * card_height) + clip_margin.y, card_width - (clip_margin.x * 2), card_height - (clip_margin.y * 2)))
	atlas_texture.set_filter_clip(true)


	front_texture = TextureRect.new()
	front_texture.texture = atlas_texture

	back_texture = TextureRect.new()
	back_texture.texture = atlas_texture

func get_tier():
	return _tier

func is_plan():
	return true
