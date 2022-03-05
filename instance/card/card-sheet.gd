extends Node

var Card = load('res://instance/card/card.gd')

var _texture
var _columns
var _rows
var _clip_margin
var _card_pixel_size


func _init(stream_texture_front, columns, rows, card_pixel_size=SC.Settings.Default_Card_Size_Pixels, margin=Vector2(5,5)):
	_columns = columns
	_rows = rows
	_card_pixel_size = card_pixel_size
	if(card_pixel_size == null):
		_card_pixel_size = SC.Settings.Default_Card_Size_Pixels
	_clip_margin = margin
	if(margin == null):
		_clip_margin = SC.Settings.Default_Card_Margin
	var texture_data: Image = stream_texture_front.get_data()
	_texture = ImageTexture.new()
	_texture.create_from_image(texture_data)
	var texture_width = _card_pixel_size.x * _columns # + (_clip_margin.x * _columns)
	var texture_height = _card_pixel_size.y * _rows # + (_clip_margin.y * _rows)
	_texture.set_size_override(Vector2(texture_width, texture_height))

func get_at_index(index):
	var region_column = (index % (_columns))
	var region_row = (index / (_columns))

	var atlas_texture = AtlasTexture.new()
	atlas_texture.set_atlas(_texture)
	var region_x = (region_column * _card_pixel_size.x) + _clip_margin.x
	var region_y = (region_row * _card_pixel_size.y) + _clip_margin.y
	var region_width = _card_pixel_size.x - (_clip_margin.x * 2)
	var region_height = _card_pixel_size.y - (_clip_margin.y * 2)
	atlas_texture.set_region(Rect2(region_x, region_y, region_width, region_height))
	atlas_texture.set_filter_clip(true)

	var image_texture = ImageTexture.new()
	image_texture.create_from_image(atlas_texture.get_image().get_data())
	var texture_rect = TextureRect.new()
	texture_rect.texture = image_texture
	texture_rect.expand = true
	texture_rect.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT)
	texture_rect.rect_min_size = _card_pixel_size

	return Card.new(texture_rect)

func get_all():
	var cards = []
	for index in range(0,_columns * _rows):
		cards.push_back(get_at_index(index))
	return cards

func get_at_location(column, row):
	return get_at_index((row * _columns) + column)
