class_name Stack
extends Reference

# Represents a stack of multiple units of a single type

var unit_reference: String
var amount: int


func _init(u: String, n: int):
	unit_reference = u
	amount = n

func load_unit() -> UnitData:
	return load("res://assets/data/%s.tres" % [unit_reference]) as UnitData
