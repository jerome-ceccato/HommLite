extends Node2D

export(Color) var hover_color

var hexgrid: HexGrid

var _hovered_cell


func setup(hexgrid: HexGrid):
	self.hexgrid = hexgrid


func _draw():
	if _hovered_cell != null:
		draw_polygon(_hovered_cell.points, [hover_color])


func _on_Grid_hex_grid_hovered(coords: BattleCoords, cell: HexCell):
	_hovered_cell = cell
	update()
