class_name UnitData
extends Reference

# Represents a unit type

var id: String

var speed: int
var initiative: int

var attack_low: int
var attack_high: int
var hp: int


func _init(_id: String, _speed: int, _initiative: int, _attackl: int, _attackh: int, _hp: int):
	id = _id
	speed = _speed
	initiative = _initiative
	attack_low = _attackl
	attack_high = _attackh
	hp = _hp
