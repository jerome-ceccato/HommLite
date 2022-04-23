extends Reference
class_name SaveData

# A serializable container for all data to be persisted

var map := AdventureMapData.new()
var hero := Hero.new()
var resources := Resources.new()


func serialized() -> Dictionary:
	return {
		"map": map.serialized(),
		"hero": hero.serialized(),
		"resources": resources.serialized(),
	}

func deserialize(data: Dictionary) -> SaveData:
	map = AdventureMapData.new().deserialize(data["map"])
	hero = Hero.new().deserialize(data["hero"])
	resources = Resources.new().deserialize(data["resources"])
	return self
