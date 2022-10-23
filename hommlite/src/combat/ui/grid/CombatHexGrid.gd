@tool
class_name CombatHexGrid
extends Node

# Represents the hex battle grid and its coordinates

@export var cell_size: int = 36 

# all the cells
var _cells: Dictionary # [BattleCoords.index: CombatHexCell]

# private internal
var _cell_width: float
var _cell_height: float
var _cell_h_offset: float
var _cell_v_offset: float
var _grid_w: float
var _grid_h: float


func setup(battle_grid: BattleGrid):
	_cell_width = cell_size * sqrt(3)
	_cell_height = cell_size * 2
	_cell_h_offset = _cell_width
	_cell_v_offset = _cell_height * 0.75

	_grid_w = _cell_h_offset * (battle_grid.cols + 1)
	_grid_h = _cell_v_offset * battle_grid.rows + (_cell_height / 4)
	
	_build_map(battle_grid)


func get_cell_at_coords(pos: BattleCoords) -> CombatHexCell:
	return _cells.get(pos.index)


func get_cell_xy(x: int, y: int) -> CombatHexCell:
	return get_cell_at_coords(BattleCoords.new(x, y))


func get_grid_size() -> Vector2:
	return Vector2(_grid_w, _grid_h)


func get_cell_coords_at_point(point: Vector2) -> BattleCoords:
	var coords = _hex_find(point)
	return coords if _cells.has(coords.index) else null


func all_cells() -> Array:
	return _cells.values()


func _build_map(battle_grid: BattleGrid):
	_cells = {}
	var effective_cell_size = Vector2(_cell_width, _cell_height)
	for coord in battle_grid.all_valid_coords():
		var base_x_offset = _cell_width if coord.y % 2 == 1 else _cell_width / 2
		var y_offset = _cell_height / 2 + (coord.y * _cell_v_offset)
		var x_offset = base_x_offset + (coord.x * _cell_h_offset)
		var cell = CombatHexCell.new(coord, effective_cell_size, Vector2(x_offset, y_offset))
		_cells[coord.index] = cell


func _hex_find(point: Vector2):
	var x = point.x - _cell_width / 2
	var y = point.y - _cell_height / 2
	var q = (x * sqrt(3) / 3 - y / 3) / cell_size
	var r = (y * 2 / 3) / cell_size
	return CombatHexUtils.cube_to_oddr(CombatHexUtils.cube_round(Vector3(q, -q-r, r)))
