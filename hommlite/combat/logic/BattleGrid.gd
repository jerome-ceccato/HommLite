class_name BattleGrid
extends Node

# Represents the hex battle grid and its coordinates

export(int, 7, 11) var rows := 9
export(int, 7, 15) var cols := 13

# All the hex valid coords
var _valid_coords: Dictionary # [BattleCoords.index: BattleCoords]

var _pathfinder: AStar2D

func _ready():
	_build_map()
	_build_pathfinder()


func all_valid_coords() -> Array:
	return _valid_coords.values()


func size() -> BattleCoords:
	return BattleCoords.new(cols, rows)


func valid_neighbors(origin: BattleCoords) -> Array:
	var all_coords = HexUtils.nearby_coords(origin, 1)
	var valid_coords = []
	for coord in all_coords:
		if _valid_coords.has(coord.index):
			valid_coords.append(coord)
	return valid_coords


func reachable_valid_coords(origin: BattleCoords, distance: int, blocked: Array) -> Array:
	var all_coords = HexUtils.reachable_coords(origin, distance, blocked)
	var valid_coords = []
	for coord in all_coords:
		if _valid_coords.has(coord.index):
			valid_coords.append(coord)
	return valid_coords


func path_find(origin: BattleCoords, target: BattleCoords, blocked: Array) -> Array:
	for coords in blocked:
		_pathfinder.set_point_disabled(coords.index, true)
	
	var path = []
	var path_indexes = _pathfinder.get_id_path(origin.index, target.index)
	for index in path_indexes:
		path.append(_valid_coords[index])
	
	for coords in blocked:
		_pathfinder.set_point_disabled(coords.index, false)
	
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
			var neighbor = HexUtils.oddr_offset_neighbor(coords, direction)
			if _valid_coords.has(neighbor.index):
				_pathfinder.connect_points(coords.index, neighbor.index, true)
