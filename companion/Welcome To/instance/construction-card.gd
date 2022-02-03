extends Node

var _kind
var _number
var _texture_index

var front_texture
var back_texture

func _init(kind, number, texture_index):    
	_kind = kind
	_number = number
	_texture_index = texture_index

	var atlas_texture = AtlasTexture.new()
	atlas_texture.set_atlas(SC.Assets.load("Welcome To", "front-"+kind+".jpg"))
	var texture_column = (texture_index % 7)
	var texture_row = (texture_index / 7)        
	var card_width = 225.42
	var card_height = 342.66
	var clip_margin = Vector2(5,5)
	atlas_texture.set_region(Rect2((texture_column * card_width) + clip_margin.x,(texture_row * card_height) + clip_margin.y, card_width - (clip_margin.x * 2), card_height - (clip_margin.y * 2)))
	atlas_texture.set_filter_clip(true)
	
	front_texture = TextureRect.new()
	front_texture.texture = atlas_texture

	var back_atlas = AtlasTexture.new()
	back_atlas.set_atlas(SC.Assets.load("Welcome To", "back-" + kind + ".jpg"))   
	back_atlas.set_region(Rect2(5,5,215,330))
	back_atlas.set_filter_clip(true)
	back_texture = TextureRect.new()
	back_texture.texture = back_atlas

func is_plan():
	return false
