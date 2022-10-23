@tool
extends Node2D

@export var color: Color = Color.BEIGE

var hexgrid: CombatHexGrid


func setup(_hexgrid: CombatHexGrid):
	hexgrid = _hexgrid


func _draw():
	for cell in hexgrid.all_cells():
		draw_polyline(cell.points, color, 1, true)
