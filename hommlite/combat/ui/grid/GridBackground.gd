extends Node2D

var hexgrid: HexGrid


func setup(_hexgrid: HexGrid):
	hexgrid = _hexgrid


func _draw():
	for cell in hexgrid.all_cells():
		draw_polyline(cell.points, Color.beige, 1, true)
	
