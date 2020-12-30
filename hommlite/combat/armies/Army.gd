extends Reference

# Represents one of the two armies in a fight
class_name Army

var stacks: Array # [UnitStack]

func _init(s: Array):
	stacks = s
