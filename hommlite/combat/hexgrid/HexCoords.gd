extends Reference

# Represents the 2D coordinates of a cell in a hex grid
class_name HexCoords

var x: int
var y: int

# to use a dictionary key
var index: int

func _init(x1: int, y1: int):
	x = x1
	y = y1
	
	index = y * 100 + x
	
func _to_string():
	return "x: %s, y: %s" % [x, y]
