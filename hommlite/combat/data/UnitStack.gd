extends Reference

# Represents a stack of multiple units of a single type
class_name UnitStack

var unit: Unit
var amount: int

func _init(u: Unit, n: int):
	unit = u
	amount = n
