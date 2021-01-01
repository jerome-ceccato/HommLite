extends Reference

# Represents a single cell in a hex grid
class_name HexCell

var coords: BattleCoords
var size: Vector2
var center: Vector2

var points: Array

func _init(coords1: BattleCoords, size1: Vector2, center1: Vector2):
	coords = coords1
	center = center1
	size = size1
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
