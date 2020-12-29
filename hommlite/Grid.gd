extends Node2D
 

const cell_size = 32
const cell_width = cell_size * sqrt(3)
const cell_height = cell_size * 2
const cell_h_offset = cell_width
const cell_v_offset = cell_height * 0.75

const n_cells_y = 9
const n_cells_x = 11

const grid_w = cell_h_offset * (n_cells_x + 1)
const grid_h = cell_v_offset * n_cells_y + (cell_height / 4)

func _draw():
	var win_w = ProjectSettings.get_setting("display/window/size/width")
	var win_h = ProjectSettings.get_setting("display/window/size/height")
	var overall_offset = Vector2((win_w - grid_w) / 2, (win_h - grid_h) / 2)
	
	for y in range(n_cells_y):
		var base_x_offset = cell_width if y % 2 == 1 else cell_width / 2
		var y_offset = cell_height / 2 + (y * cell_v_offset)
		var x_range = n_cells_x if y % 2 == 1 else n_cells_x + 1
		for x in range(x_range):
			var x_offset = base_x_offset + (x * cell_h_offset)
			draw_hex_cell(overall_offset + Vector2(x_offset, y_offset))
			
	# bounding box (debug)
	#draw_bounding_box(overall_offset)
	

func draw_bounding_box(origin):
	var visual_offset = 3
	var min_x = -visual_offset
	var min_y = -visual_offset
	var max_x = grid_w + visual_offset
	var max_y = grid_h + visual_offset
	
	var color = Color.red
	color.a = 0.8
	
	draw_polyline([
		origin + Vector2(min_x, min_y),
		origin + Vector2(max_x, min_y),
		origin + Vector2(max_x, max_y),
		origin + Vector2(min_x, max_y),
		origin + Vector2(min_x, min_y)
	], color, 1)

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
	
	draw_polyline(points, Color.beige, 1, true)
