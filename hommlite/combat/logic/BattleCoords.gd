class_name BattleCoords
extends Reference

# Represents the 2D coordinates of a unit in the battlefield

var x: int
var y: int

# to use as a dictionary key
var index: int 


func _init(_x: int, _y: int):
	x = _x
	y = _y
	
	index = (y * 100) + x
