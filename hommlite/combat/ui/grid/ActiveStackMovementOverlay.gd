extends GridOverlayBase

export(Color) var overlayed_color

func draw_cell(cell: HexCell):
	draw_polygon(cell.points, [overlayed_color])

func _on_BattleQueue_active_stack_changed(stack: BattleStack):
	update_overlay(stack)

func _on_BattleQueue_stack_moved(stack: BattleStack):
	update_overlay(stack)
