extends Reference

# Represents a unit type
class_name UnitData

var id: String

var speed: int
var initiative: int

func _init(_id: String, _speed: int, _initiative: int):
	id = _id
	speed = _speed
	initiative = _initiative
