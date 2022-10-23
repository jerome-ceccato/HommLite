extends RefCounted
class_name SaveData

# A serializable container for all data to be persisted

var hero := Hero.new()
var resources := Resources.new()


func serialized() -> Dictionary:
	return {
		"hero": hero.serialized(),
		"resources": resources.serialized(),
	}

func deserialize(data: Dictionary) -> SaveData:
	hero = Hero.new().deserialize(data["hero"])
	resources = Resources.new().deserialize(data["resources"])
	return self
