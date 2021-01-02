class_name GridOverlayBase
extends Node2D

var hexgrid: HexGrid
var battle: Battle

var all_cells_overlayed: Array # [HexCell]


func setup(_hexgrid: HexGrid, _battle: Battle):
	hexgrid = _hexgrid
	battle = _battle


func _draw():
	for cell in all_cells_overlayed:
		draw_cell(cell)


func draw_cell(cell: HexCell):
	assert(false)


func update_overlay(stack: BattleStack):
	all_cells_overlayed = _cells_for_stack(stack)
	update()


func _cells_for_stack(stack: BattleStack) -> Array:
	if stack != null:
		var nearby_coords = battle.grid.nearby_valid_coords(stack.coordinates, stack.stack.unit.speed)
		var nearby_cells = []
		for coord in nearby_coords:
			var maybe_cell = hexgrid.get_cell_at_coords(coord)
			if maybe_cell:
				nearby_cells.append(maybe_cell)
		return nearby_cells
	else:
		return []
