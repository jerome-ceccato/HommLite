class_name WorldData
extends Reference

var name: String
var preview_ref: String
var difficulty: String
var rewards: String

var id: String
var reward_value: int

func _init(_name: String, _preview_ref: String, _difficulty: String, _rewards: String, _id: String, _reward_value: int):
	name = _name
	preview_ref = _preview_ref
	difficulty = _difficulty
	rewards = _rewards
	id = _id
	reward_value = _reward_value
