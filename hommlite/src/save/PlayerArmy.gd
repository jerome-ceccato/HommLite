class_name PlayerArmy
extends Reference

static func get_army() -> Army:
	return Army.new([
		Stack.new("cow", 9),
		Stack.new("uchicken", 9),
	])
