extends RefCounted
class_name Hero

var army: Army

func _init():
	reset_army()

func reset_army():
	army = Army.new({
		0: Stack.new("cow", 9),
		1: Stack.new("uchicken", 9),
		2: Stack.new("bee", 3),
	})

func serialized() -> Dictionary:
	return {
		"army": army.serialized(),
	}

func deserialize(data: Dictionary) -> Hero:
	army = Army.new({}).deserialize(data["army"])
	return self
