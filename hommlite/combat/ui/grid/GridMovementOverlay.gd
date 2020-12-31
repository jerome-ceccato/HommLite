extends Node2D

export(Color) var overlayed_color

var hexgrid: HexGrid
var battle: Battle

var all_cells_overlayed: Array # [HexCell]

func setup(_hexgrid: HexGrid, _battle: Battle):
	hexgrid = _hexgrid
	battle = _battle

func _draw():
	for cell in all_cells_overlayed:
		draw_polygon(cell.points, [overlayed_color])

func _update_overlay(cells: Array):
	all_cells_overlayed = cells
	update()

func _on_Grid_hex_grid_hovered(coords: BattleCoords, cell: HexCell):
	if coords != null:
		var stack = battle.get_stack_at(coords)
		if stack != null:
			var nearby_coords = hexgrid.nearby_cells(coords, stack.stack.unit.speed)
			var nearby_cells = []
			for coord in nearby_coords:
				var maybe_cell = hexgrid.get_cell_at_coords(coord)
				if maybe_cell:
					nearby_cells.append(maybe_cell)
			_update_overlay(nearby_cells)
		else:
			_update_overlay([])
	else:
		_update_overlay([])
