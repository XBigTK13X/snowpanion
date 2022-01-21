extends Node

var _name
var _texture_index

var front_texture
var back_texture

func init(name, texture_index): 
    _name = name
    _texture_index = texture_index

    var cards_texture = SC.Assets.load("Welcome To", "front-solo.jpg")

    var atlas_texture = AtlasTexture.new()
    atlas_texture.set_atlas(cards_texture)
    var texture_column = (texture_index % 3)
    var texture_row = (texture_index / 3)    
    atlas_texture.set_region(Rect2(15 + (texture_column * (210 + 10)), 15 + (texture_row * (320 + 30)) , 210, 320))
    atlas_texture.set_filter_clip(true)
    
    front_texture = TextureRect.new()
    front_texture.texture = atlas_texture

    back_texture = TextureRect.new()
    back_texture.texture = atlas_texture