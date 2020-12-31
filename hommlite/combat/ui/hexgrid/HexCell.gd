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
	points = [
		Vector2(center.x - (size.x / 2), center.y - (size.y / 4)),
		Vector2(center.x, center.y - (size.y / 2)),
		Vector2(center.x + (size.x / 2), center.y - (size.y / 4)),
		Vector2(center.x + (size.x / 2), center.y + (size.y / 4)),
		Vector2(center.x, center.y + (size.y / 2)),
		Vector2(center.x - (size.x / 2), center.y + (size.y / 4)),
		Vector2(center.x - (size.x / 2), center.y - (size.y / 4))
	]
