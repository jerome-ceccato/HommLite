extends Reference

# Represents one of the two armies in a fight
class_name ArmyData

var stacks: Array # [StackData]

func _init(s: Array):
	stacks = s
