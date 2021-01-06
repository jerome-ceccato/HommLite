class_name BattleGrid
extends Node

# Represents the hex battle grid and its coordinates

export(int, 7, 11) var rows := 9
export(int, 7, 15) var cols := 13

# All the hex valid coords
var _valid_coords: Dictionary # [BattleCoords.index: BattleCoords]


func _ready():
	_build_map()


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


func _build_map():
	_valid_coords = {}
	for y in range(rows):
		var x_range = cols if y % 2 == 1 else cols + 1
		for x in range(x_range):
			var pos = BattleCoords.new(x, y)
			_valid_coords[pos.index] = pos
