extends Reference
class_name Resources

var gold := 0


func serialized() -> Dictionary:
	return {
		"gold": gold,
	}

func deserialize(data: Dictionary) -> Resources:
	gold = int(data["gold"])
	return self
