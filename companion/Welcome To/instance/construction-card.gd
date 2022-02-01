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

    var cards_texture = SC.Assets.load("Welcome To", "front-"+kind+".jpg")

    var atlas_texture = AtlasTexture.new()
    atlas_texture.set_atlas(cards_texture)
    var texture_column = (texture_index % 7)
    var texture_row = (texture_index / 7)    
    atlas_texture.set_region(Rect2(15 + (texture_column * (210 + 10)), 15 + (texture_row * (320 + 30)) , 210, 320))
    atlas_texture.set_filter_clip(true)
    
    front_texture = TextureRect.new()
    front_texture.texture = atlas_texture

    back_texture = TextureRect.new()
    back_texture.texture = SC.Assets.load("Welcome To", "back-" + kind + ".jpg")

func is_plan():
    return false