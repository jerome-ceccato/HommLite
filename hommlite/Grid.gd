extends Node2D

const cell_size = 24
const cell_width = cell_size * sqrt(3)
const cell_height = cell_size * 2

const n_cells_x = 17
const n_cells_y = 13

func _draw():
	var overall_offset = Vector2(10, 10)
	
	for y in range(n_cells_y):
		var base_x_offset = cell_width if y % 2 == 0 else cell_width / 2
		var y_offset = cell_height / 2 + (y * (cell_height * 0.75))
		for x in range(n_cells_x):
			var x_offset = base_x_offset + (x * cell_width)
			draw_hex_cell(overall_offset + Vector2(x_offset, y_offset))


func draw_hex_cell(center):
	var points = [
		Vector2(center.x - (cell_width / 2), center.y - (cell_height / 4)),
		Vector2(center.x, center.y - (cell_height / 2)),
		Vector2(center.x + (cell_width / 2), center.y - (cell_height / 4)),
		Vector2(center.x + (cell_width / 2), center.y + (cell_height / 4)),
		Vector2(center.x, center.y + (cell_height / 2)),
		Vector2(center.x - (cell_width / 2), center.y + (cell_height / 4)),
		Vector2(center.x - (cell_width / 2), center.y - (cell_height / 4))
	]
	
	draw_polyline(points, Color.red, 1, true)
