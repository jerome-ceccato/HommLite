class_name UnitData
extends Reference

# Represents a unit type

var id: String
var display_name: String
var display_name_plural: String

var speed: int
var initiative: int

var flying: bool

var attack_low: int
var attack_high: int
var hp: int


func _init(_id: String, _display_name: String, _display_name_plural: String, _speed: int, _initiative: int, _flying: bool, _attackl: int, _attackh: int, _hp: int):
	id = _id
	display_name = _display_name
	display_name_plural = _display_name_plural
	speed = _speed
	initiative = _initiative
	flying = _flying
	attack_low = _attackl
	attack_high = _attackh
	hp = _hp
