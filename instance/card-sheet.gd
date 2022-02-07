extends Node

var Card = load('res://instance/card.gd')

var _texture
var _columns
var _rows
var _card_height
var _card_width
var _clip_margin

func _init(texture, columns, rows, margin=Vector2(5,5)):
	_texture = texture
	_rows = rows
	_columns = columns
	_card_width = _texture.get_width() / columns
	_card_height = _texture.get_height() / rows
	_clip_margin = margin

func get_at_index(index):
	var atlas_texture = AtlasTexture.new()
	atlas_texture.set_atlas(_texture)
	var region_column = (index % _columns)
	var region_row = (index / _rows)
	atlas_texture.set_region(Rect2((region_column * _card_width) + _clip_margin.x, (region_row * _card_height) + _clip_margin.y, _card_width - (_clip_margin.x * 2), _card_height - (_clip_margin.y * 2)))
	atlas_texture.set_filter_clip(true)
	var texture = TextureRect.new()
	texture.texture = atlas_texture
	return Card.new(texture)

func get_all():
	var cards = []
	for index in range(0,_columns*_rows):
		cards.push_back(get_at_index(index))
	return cards

func get_at_location(column, row):
	return get_at_index((row * _columns) + column)
