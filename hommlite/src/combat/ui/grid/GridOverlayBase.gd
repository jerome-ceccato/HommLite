class_name GridOverlayBase
extends Node2D

var hexgrid: CombatHexGrid
var battle: Battle

var all_cells_overlayed: Array # [CombatHexCell]


func setup(_hexgrid: CombatHexGrid, _battle: Battle):
	hexgrid = _hexgrid
	battle = _battle


func _draw():
	for cell in all_cells_overlayed:
		draw_cell(cell)


func draw_cell(_cell: CombatHexCell):
	assert(false)


func update_overlay(stack: BattleStack):
	all_cells_overlayed = _cells_for_stack(stack)
	queue_redraw()


func _cells_for_stack(stack: BattleStack) -> Array:
	if stack != null:
		var coords = battle.reachable_coords(stack)
		var cells = []
		for coord in coords:
			var maybe_cell = hexgrid.get_cell_at_coords(coord)
			if maybe_cell:
				cells.append(maybe_cell)
		return cells
	else:
		return []
