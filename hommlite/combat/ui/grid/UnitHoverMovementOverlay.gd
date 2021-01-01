extends GridOverlayBase

export(Color) var overlayed_color

func draw_cell(cell: HexCell):
	draw_polygon(cell.make_points_size(20), [overlayed_color])

func _on_Grid_hex_grid_hovered(coords: BattleCoords, cell: HexCell):
	if coords != null:
		var stack = battle.state.get_stack_at(coords)
		if stack != null:
			if !battle.queue.stack_is_active(stack):
				update_overlay(stack)
				return
	update_overlay(null)
