@tool
class_name CombatHexCell
extends RefCounted

# Represents a single cell in a hex grid

var coords: BattleCoords
var size: Vector2
var center: Vector2

var points: Array


func _init(_coords: BattleCoords,_size: Vector2,_center: Vector2):
	coords = _coords
	center = _center
	size = _size
	points = make_points(size)


func make_points_size(cell_size: float):
	return make_points(Vector2(cell_size * sqrt(3), cell_size * 2))


func make_points(hex_size: Vector2):
	return [
		Vector2(center.x - (hex_size.x / 2), center.y - (hex_size.y / 4)),
		Vector2(center.x, center.y - (hex_size.y / 2)),
		Vector2(center.x + (hex_size.x / 2), center.y - (hex_size.y / 4)),
		Vector2(center.x + (hex_size.x / 2), center.y + (hex_size.y / 4)),
		Vector2(center.x, center.y + (hex_size.y / 2)),
		Vector2(center.x - (hex_size.x / 2), center.y + (hex_size.y / 4)),
		Vector2(center.x - (hex_size.x / 2), center.y - (hex_size.y / 4))
	]
