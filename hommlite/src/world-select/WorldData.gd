class_name WorldData
extends Reference

var name: String
var preview_ref: String
var difficulty: float
var reward: int


func _init(_name: String, _preview_ref: String, _difficulty: float, _reward: int):
	name = _name
	preview_ref = _preview_ref
	difficulty = _difficulty
	reward = _reward


func serialized() -> Dictionary:
	return {
		"name": name,
		"preview_ref": preview_ref,
		"difficulty": difficulty,
		"reward": reward
	}

func deserialize(data: Dictionary) -> WorldData:
	name = data["name"]
	preview_ref = data["preview_ref"]
	difficulty = data["difficulty"]
	reward = data["reward"]
	return self
