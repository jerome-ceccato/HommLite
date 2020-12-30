extends Reference

# Represents a unit type
class_name Unit

enum Type {GOBLIN, SKELETON}
var type: int

func _init(t: int):
	type = t
