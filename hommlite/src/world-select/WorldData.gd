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


func serialized() -> Dictionary:
	return {
		"name": name,
		"preview_ref": preview_ref,
		"difficulty": difficulty,
		"rewards": rewards
	}

func deserialize(data: Dictionary) -> WorldData:
	name = data["name"]
	preview_ref = data["preview_ref"]
	difficulty = data["difficulty"]
	rewards = data["rewards"]
	return self
