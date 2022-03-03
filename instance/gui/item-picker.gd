extends ScrollContainer

func _init(items, grid_columns, select_context, select_action):
	rect_min_size = Vector2(1900, 1060)
	get_v_scrollbar().rect_min_size.x = 35
	get_h_scrollbar().rect_min_size.y = 35
	margin_top = 10
	margin_left = 10
	var item_grid = SC.Static.MarginGridContainer.build(grid_columns)

	for item in items:
		var button = item.get_picker_button()
		button.connect('pressed', select_context, select_action, [item])
		item_grid.add_child(button)

	add_child(item_grid)
