class_name ArmyData
extends Reference

# Represents one of the two armies in a fight

var stacks: Array # [StackData]


func _init(s: Array):
	stacks = s
