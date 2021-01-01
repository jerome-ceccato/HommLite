extends Reference

# Represents the 2D coordinates of a unit in the battlefield
class_name BattleCoords

var x: int
var y: int

# to use as a dictionary key
var index: int

func _init(x1: int, y1: int):
	x = x1
	y = y1
	
	index = (y * 100) + x
