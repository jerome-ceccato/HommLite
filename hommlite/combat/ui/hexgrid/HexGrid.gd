extends Reference

# Represents the hex battle grid and its coordinates
class_name HexGrid

# all the cells
var cells: Dictionary # [BattleCoords.index: HexCell]

# private internal
var cell_size: int
var cells_row_count: int
var cells_col_count: int

var cell_width: float
var cell_height: float
var cell_h_offset: float
var cell_v_offset: float
var grid_w: float
var grid_h: float

func _init(cell_size: int, battlefield_size: BattleCoords):
	self.cell_size = cell_size
	cells_col_count = battlefield_size.x
	cells_row_count = battlefield_size.y

	cell_width = cell_size * sqrt(3)
	cell_height = cell_size * 2
	cell_h_offset = cell_width
	cell_v_offset = cell_height * 0.75

	grid_w = cell_h_offset * (cells_col_count + 1)
	grid_h = cell_v_offset * cells_row_count + (cell_height / 4)
	
	_build_map()

func get_cell_at_coords(pos: BattleCoords) -> HexCell:
	var index = pos.index
	return cells[index] if cells.has(index) else null
	
func get_cell_xy(x: int, y: int) -> HexCell:
	return get_cell_at_coords(BattleCoords.new(x, y))

func get_grid_size() -> Vector2:
	return Vector2(grid_w, grid_h)

func get_cell_coords_at_point(point: Vector2) -> BattleCoords:
	var coords = hex_find(point)
	return coords if cells.has(coords.index) else null

func get_cell_at_point(point: Vector2) -> HexCell:
	var pos = hex_find(point)
	return get_cell_at_coords(pos)

func _build_map():
	cells = {}
	var cell_size = Vector2(cell_width, cell_height)
	for y in range(cells_row_count):
		var base_x_offset = cell_width if y % 2 == 1 else cell_width / 2
		var y_offset = cell_height / 2 + (y * cell_v_offset)
		var x_range = cells_col_count if y % 2 == 1 else cells_col_count + 1
		
		for x in range(x_range):
			var x_offset = base_x_offset + (x * cell_h_offset)
			var pos = BattleCoords.new(x, y)
			var cell = HexCell.new(pos, cell_size, Vector2(x_offset, y_offset))
			cells[pos.index] = cell

# Hex operations
# Adapted from https://www.redblobgames.com/grids/hexagons

func nearby_cells(origin: BattleCoords, distance: int) -> Array:
	var center = _oddr_to_cube(origin)
	var results = []
	for x in range(-distance, distance + 1):
		for y in range(max(-distance, -x - distance), min(distance, -x + distance) + 1):
			var z = -x - y
			var cube = center + Vector3(x, y, z)
			results.append(_cube_to_oddr(cube))
	return results

func hex_find(point: Vector2):
	var x = point.x - cell_width / 2
	var y = point.y - cell_height / 2
	var q = (x * sqrt(3) / 3 - y / 3) / cell_size
	var r = (y * 2 / 3) / cell_size
	return _cube_to_oddr(_cube_round(Vector3(q, -q-r, r)))

func _cube_round(cube: Vector3):
	var rx = round(cube.x)
	var ry = round(cube.y)
	var rz = round(cube.z)
	
	var x_diff = abs(rx - cube.x)
	var y_diff = abs(ry - cube.y)
	var z_diff = abs(rz - cube.z)

	if x_diff > y_diff and x_diff > z_diff:
		rx = -ry - rz
	elif y_diff > z_diff:
		ry = -rx - rz
	else:
		rz = -rx - ry

	return Vector3(rx, ry, rz)

func _cube_to_oddr(cube: Vector3):
	var x = int(cube.x)
	var z = int(cube.z)
	var col = x + (z - (z & 1)) / 2
	var row = z
	return BattleCoords.new(col, row)

func _oddr_to_cube(hex: BattleCoords):
	var x = hex.x - (hex.y - (hex.y & 1)) / 2
	var z = hex.y
	var y = -x - z
	return Vector3(x, y, z)
