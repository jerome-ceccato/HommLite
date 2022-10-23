@tool
class_name BattleGrid
extends Node

# Represents the hex battle grid and its coordinates

# Editor only
@export var rows := 9 # (int, 7, 11)
@export var cols := 13 # (int, 7, 15)

# All the hex valid coords
var _valid_coords: Dictionary # [BattleCoords.index: BattleCoords]

var _pathfinder: AStar2D

func _ready():
	if Engine.is_editor_hint():
		setup(BattleCoords.new(cols, rows))


func setup(map_size: BattleCoords):
	rows = map_size.y
	cols = map_size.x
	_build_map()
	_build_pathfinder()


func all_valid_coords() -> Array:
	return _valid_coords.values()


func size() -> BattleCoords:
	return BattleCoords.new(cols, rows)


func valid_neighbors(origin: BattleCoords) -> Array:
	var all_coords = CombatHexUtils.nearby_coords(origin, _valid_coords, 1)
	var valid_coords = []
	for coord in all_coords:
		if _valid_coords.has(coord.index):
			valid_coords.append(coord)
	return valid_coords


func reachable_valid_coords(origin: BattleCoords, distance: int, blocked: Array, large: bool) -> Array:
	return CombatHexUtils.reachable_coords(origin, _valid_coords, distance, blocked, large)


func path_find(origin: BattleStack, target: BattleCoords, allowed_points: Array) -> Array:
	var lookup = {}
	for point in allowed_points:
		lookup[point.index] = point
	
	for coords in _valid_coords.values():
		var enabled = lookup.has(coords.index) or origin.unit.flying
		_pathfinder.set_point_disabled(coords.index, !enabled)
	
	var path = []
	var path_indexes = _pathfinder.get_id_path(origin.coordinates.index, target.index)
	for index in path_indexes:
		path.append(_valid_coords[index])
	
	return path


func _build_map():
	_valid_coords = {}
	for y in range(rows):
		var x_range = cols if y % 2 == 1 else cols + 1
		for x in range(x_range):
			var pos = BattleCoords.new(x, y)
			_valid_coords[pos.index] = pos


func _build_pathfinder():
	_pathfinder = AStar2D.new()
	
	# build all points
	for coords in _valid_coords.values():
		_pathfinder.add_point(coords.index, Vector2(coords.x, coords.y))
	# connect all points to each other
	for coords in _valid_coords.values():
		for direction in range(6):
			var neighbor = CombatHexUtils.oddr_offset_neighbor(coords, direction)
			if _valid_coords.has(neighbor.index):
				_pathfinder.connect_points(coords.index, neighbor.index, true)
