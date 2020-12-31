extends Node2D

signal hex_grid_hovered

var hexgrid: HexGrid

var last_hovered_cell

func setup(hexgrid: HexGrid):
	self.hexgrid = hexgrid
	
func _draw():
	if last_hovered_cell != null:
		var color = Color.black
		color.a = 0.2
		draw_polygon(last_hovered_cell.points, [color])

func _process(delta):
	var mouse_pos = get_local_mouse_position()
	var new_cell = hexgrid.get_cell_at_point(mouse_pos)
	if last_hovered_cell != new_cell:
		last_hovered_cell = new_cell
		emit_signal("hex_grid_hovered", new_cell)
		update()
