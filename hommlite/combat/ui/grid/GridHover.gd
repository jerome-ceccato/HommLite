extends Node2D

export(Color) var hover_color

var hexgrid: HexGrid

var hovered_cell

func setup(hexgrid: HexGrid):
	self.hexgrid = hexgrid
	
func _draw():
	if hovered_cell != null:
		draw_polygon(hovered_cell.points, [hover_color])

func _on_Grid_hex_grid_hovered(coords: BattleCoords, cell: HexCell):
	hovered_cell = cell
	update()
