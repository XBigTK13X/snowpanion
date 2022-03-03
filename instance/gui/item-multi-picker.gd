extends ScrollContainer

var _select_item_count
var _selection = {}
var _callback

var _selection_list
var _item_grid

func _init(items, item_height_pixels, grid_columns, select_item_count, callback):
	_callback = callback
	_select_item_count = select_item_count

	var vbox = VBoxContainer.new()
	_selection_list = HBoxContainer.new()
	_selection_list.set_alignment(BoxContainer.ALIGN_CENTER)
	_selection_list.rect_min_size = Vector2(0, item_height_pixels)

	rect_min_size = Vector2(1900, 1060)
	get_v_scrollbar().rect_min_size.x = 35
	get_h_scrollbar().rect_min_size.y = 35
	margin_top = 10
	margin_left = 10
	_item_grid = SC.Static.MarginGridContainer.build(grid_columns)
	_item_grid.rect_min_size = Vector2(1900, item_height_pixels)

	for item in items:
		var button = item.get_picker_button()
		button.connect('pressed', self, '_select_item', [item])
		_item_grid.add_child(button)

	SC.link(vbox, _selection_list)
	SC.link(vbox, _item_grid)
	SC.link(self, vbox)

func _select_item(item):
	var item_id = item.get_instance_id()
	if item_id in _selection:
		_selection.erase(item_id)
	else:
		_selection[item_id] = item
	if _selection.size() >= _select_item_count:
		_callback.call_func(_selection.values())
	else:
		SC.clean(_selection_list, false)
		for item_key in _selection:
			var selected_item = _selection[item_key]
			var button = selected_item.get_picker_button()
			button.connect('pressed', self, '_select_item', [selected_item])
			_selection_list.add_child(button)