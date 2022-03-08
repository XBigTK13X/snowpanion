extends Node

var Version = "0.0.2"
var Card_Size_MM = Vector2(63, 88)
var Default_Card_Size_Pixels = Vector2(Card_Size_MM.x * 3.5, Card_Size_MM.y * 3.5)
var Default_Card_Margin = Vector2(5,5)
var Card_Zoom_Multiply = 5
var HighlightButtonHighlight = Color(1,1,1,1)
var HighlightButtonDarken = Color(0.5,0.5,0.5,1)
var HighlightButtonNormal = Color(0.9,0.9,0.9,0.9)

func display_size():
	return get_viewport().size