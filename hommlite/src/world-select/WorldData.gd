class_name WorldData
extends Reference

var name: String
var preview_ref: String
var difficulty: String
var rewards: String

func _init(_name: String, _preview_ref: String, _difficulty: String, _rewards: String):
	name = _name
	preview_ref = _preview_ref
	difficulty = _difficulty
	rewards = _rewards
