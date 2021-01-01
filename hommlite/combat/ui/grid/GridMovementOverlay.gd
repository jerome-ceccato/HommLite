extends GridOverlayBase

export(Color) var overlayed_color

func draw_cell(cell: HexCell):
	draw_polygon(cell.make_points_size(20), [overlayed_color])

func _on_Grid_hex_grid_hovered(coords: BattleCoords, cell: HexCell):
	if coords != null:
		var stack = battle.get_stack_at(coords)
		update_overlay(stack)
	else:
		update_overlay(null)
