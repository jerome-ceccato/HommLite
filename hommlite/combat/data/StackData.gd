extends Reference

# Represents a stack of multiple units of a single type
class_name StackData

var unit: UnitData
var amount: int

func _init(u: UnitData, n: int):
	unit = u
	amount = n
