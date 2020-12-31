extends Node2D

export(Color) var overlayed_color

var hexgrid: HexGrid

var all_cells_overlayed: Array # [HexCell]

func setup(hexgrid: HexGrid):
	self.hexgrid = hexgrid

func update_overlay(cells: Array):
	all_cells_overlayed = cells
	update()

func _draw():
	for cell in all_cells_overlayed:
		draw_polygon(cell.points, [overlayed_color])

func _on_Grid_hex_grid_hovered(coords: BattleCoords, cell: HexCell):
	if coords != null:
		var nearby_coords = hexgrid.nearby_cells(coords, 3)
		var nearby_cells = []
		for coord in nearby_coords:
			var maybe_cell = hexgrid.get_cell(coord)
			if maybe_cell:
				nearby_cells.append(maybe_cell)
		update_overlay(nearby_cells)
	else:
		update_overlay([])
