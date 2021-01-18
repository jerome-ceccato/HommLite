tool
extends Node2D

export(Color) var color := Color.beige

var hexgrid: HexGrid


func setup(_hexgrid: HexGrid):
	hexgrid = _hexgrid


func _draw():
	for cell in hexgrid.all_cells():
		draw_polyline(cell.points, color, 1, true)
