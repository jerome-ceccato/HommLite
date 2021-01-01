extends Node

# Represents the hex battle grid and its coordinates
class_name BattleGrid

# editable
export(int) var rows := 9
export(int) var cols := 13

# All the hex valid coords
var _valid_coords: Dictionary # [BattleCoords.index: BattleCoords]

func _ready():
	_build_map()

func get_cell_at_coords(pos: BattleCoords) -> HexCell:
	return _valid_coords.get(pos.index)
	
func get_cell_xy(x: int, y: int) -> HexCell:
	return get_cell_at_coords(BattleCoords.new(x, y))

func all_valid_coords() -> Array:
	return _valid_coords.values()

func size() -> BattleCoords:
	return BattleCoords.new(cols, rows)

func _build_map():
	_valid_coords = {}
	for y in range(rows):
		var x_range = cols if y % 2 == 1 else cols + 1
		for x in range(x_range):
			var pos = BattleCoords.new(x, y)
			_valid_coords[pos.index] = pos

func nearby_valid_coords(origin: BattleCoords, distance: int) -> Array:
	var all_coords = HexUtils.nearby_coords(origin, distance)
	var valid_coords = []
	for coord in all_coords:
		if _valid_coords.has(coord.index):
			valid_coords.append(coord)
	return valid_coords
