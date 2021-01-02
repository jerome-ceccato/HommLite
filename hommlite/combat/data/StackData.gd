class_name StackData
extends Reference

# Represents a stack of multiple units of a single type

var unit: UnitData
var amount: int


func _init(u: UnitData, n: int):
	unit = u
	amount = n
