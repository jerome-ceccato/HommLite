extends Node

class_name AdventureSaveData

var hexmap := {}
var player_pos := Vector3.ZERO


func serialized() -> Dictionary:
	return {
		"hexmap": _serialized_hexmap(hexmap),
		"player_pos": var2str(player_pos),
	}

func deserialize(data: Dictionary) -> AdventureSaveData:
	hexmap = _deserialized_dict(data["hexmap"])
	player_pos = str2var(data["player_pos"])
	return self


func _serialized_hexmap(dict: Dictionary):
	var serialized = {}
	for key in dict:
		serialized[var2str(key)] = dict[key].serialized()
	return serialized

func _deserialized_dict(dict: Dictionary):
	var serialized = {}
	for key in dict:
		serialized[str2var(key)] = AdventureTile.new(0,0,0,0).deserialize(dict[key])
	return serialized
