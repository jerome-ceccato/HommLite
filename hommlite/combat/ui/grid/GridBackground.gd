extends Node2D

var hexgrid: HexGrid

func setup(hexgrid: HexGrid):
	self.hexgrid = hexgrid
	
func _draw():
	for cell in hexgrid.all_cells():
		draw_polyline(cell.points, Color.beige, 1, true)
	
