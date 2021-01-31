class_name StartData
extends Reference

static func get_player_army() -> Army:
	return Army.new([
		Stack.new("cow", 9),
		Stack.new("uchicken", 9),
	])
