extends Reference
class_name SaveData

# A serializable container for all data to be persisted

var map := {}
var hero := Hero.new()
var resources := Resources.new()
var player_pos := Vector3.ZERO


func serialized() -> Dictionary:
	return {
		"map": _serialized_hexmap(map),
		"hero": hero.serialized(),
		"resources": resources.serialized(),
		"player_pos": var2str(player_pos),
	}

func deserialize(data: Dictionary) -> SaveData:
	map = _deserialized_dict(data["map"])
	hero = Hero.new().deserialize(data["hero"])
	resources = Resources.new().deserialize(data["resources"])
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
		serialized[str2var(key)] = AdventureTile.new(0,0,null,0).deserialize(dict[key])
	return serialized
