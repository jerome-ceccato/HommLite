class_name StartData
extends Reference

static func get_player_army() -> Army:
	return Army.new({
		0: Stack.new("cow", 9),
		1: Stack.new("uchicken", 9),
	})
