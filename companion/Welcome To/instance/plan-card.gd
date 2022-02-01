extends Node

var _plan

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
    atlas_texture.set_region(Rect2(15 + (texture_column * (210 + 10)), 15 + (texture_row * (320 + 30)) , 210, 320))
    atlas_texture.set_filter_clip(true)
    var texture = TextureRect.new()
    texture.texture = atlas_texture
    return texture

func get_plan():
    return _plan