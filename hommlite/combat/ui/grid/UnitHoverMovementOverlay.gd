extends GridOverlayBase

export(Color) var overlayed_color

var _shift_pressed = false
var _last_hovered_coords: BattleCoords

func draw_cell(cell: HexCell):
	draw_polygon(cell.make_points_size(20), [overlayed_color])

func _input(event):
	if event is InputEventKey and event.scancode == KEY_SHIFT:
		_shift_pressed = event.pressed
		_update(_last_hovered_coords)

func _on_Grid_hex_grid_hovered(coords: BattleCoords, cell: HexCell):
	_last_hovered_coords = coords
	_update(coords)

func _update(coords: BattleCoords):
	if coords != null:
		var stack = battle.state.get_stack_at(coords)
		if _should_show_overlay_for_stack(stack):
			update_overlay(stack)
		else:
			update_overlay(null)
	else:
		update_overlay(null)

func _should_show_overlay_for_stack(stack: BattleStack) -> bool:
	if stack == null or !_shift_pressed:
		return false
	return !battle.queue.stack_is_active(stack)
