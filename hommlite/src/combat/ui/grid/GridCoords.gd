tool
extends Node2D

export(Font) var font: Font
export(Color) var color := Color.beige

var hexgrid: CombatHexGrid


func setup(_hexgrid: CombatHexGrid):
	hexgrid = _hexgrid


func _draw():
	for cell in hexgrid.all_cells():
		var offset = Vector2(-10, 8)
		var coords_text = "%s,%s" % [cell.coords.x, cell.coords.y]
		draw_string(font, cell.center + offset, coords_text, color)
