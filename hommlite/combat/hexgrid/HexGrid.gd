extends Node

# editable
export(int) var cell_size := 32
export(int) var cells_row_count := 9
export(int) var cells_col_count := 13

# all the cells
var cells: Dictionary # [str(HexCoords): HexCell]

# private internal
var cell_width: float
var cell_height: float
var cell_h_offset: float
var cell_v_offset: float
var grid_w: float
var grid_h: float

func _ready():
	cell_width = cell_size * sqrt(3)
	cell_height = cell_size * 2
	cell_h_offset = cell_width
	cell_v_offset = cell_height * 0.75

	grid_w = cell_h_offset * (cells_col_count + 1)
	grid_h = cell_v_offset * cells_row_count + (cell_height / 4)
	
	build_map()

func build_map():
	cells = {}
	var cell_size = Vector2(cell_width, cell_height)
	for y in range(cells_row_count):
		var base_x_offset = cell_width if y % 2 == 1 else cell_width / 2
		var y_offset = cell_height / 2 + (y * cell_v_offset)
		var x_range = cells_col_count if y % 2 == 1 else cells_col_count + 1
		
		for x in range(x_range):
			var x_offset = base_x_offset + (x * cell_h_offset)
			var pos = HexCoords.new(x, y)
			var cell = HexCell.new(pos, cell_size, Vector2(x_offset, y_offset))
			cells[pos.index] = cell

func get_cell(pos: HexCoords) -> HexCell:
	var index = pos.index
	return cells[index] if cells.has(index) else null
	
func get_cell_xy(x: int, y: int) -> HexCell:
	return get_cell(HexCoords.new(x, y))

func get_grid_size() -> Vector2:
	return Vector2(grid_w, grid_h)

func get_cell_index_at_point(point: Vector2) -> HexCoords:
	return hex_find(point)

func get_cell_at_point(point: Vector2) -> HexCell:
	var pos = get_cell_index_at_point(point)
	return get_cell(pos)

func get_size() -> HexCoords:
	return HexCoords.new(cells_col_count, cells_row_count)

# Hex operations
# Adapted from https://www.redblobgames.com/grids/hexagons

func hex_find(point: Vector2):
	var x = point.x - cell_width / 2
	var y = point.y - cell_height / 2
	var q = (x * sqrt(3) / 3 - y / 3) / cell_size
	var r = (y * 2 / 3) / cell_size
	return cube_to_oddr(cube_round(Vector3(q, -q-r, r)))

func cube_round(cube: Vector3):
	var rx = round(cube.x)
	var ry = round(cube.y)
	var rz = round(cube.z)
	
	var x_diff = abs(rx - cube.x)
	var y_diff = abs(ry - cube.y)
	var z_diff = abs(rz - cube.z)

	if x_diff > y_diff and x_diff > z_diff:
		rx = -ry-rz
	elif y_diff > z_diff:
		ry = -rx-rz
	else:
		rz = -rx-ry

	return Vector3(rx, ry, rz)

func cube_to_oddr(cube: Vector3):
	var x = int(cube.x)
	var z = int(cube.z)
	var col = x + (z - (z&1)) / 2
	var row = z
	return HexCoords.new(col, row)
