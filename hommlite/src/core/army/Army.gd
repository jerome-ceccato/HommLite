class_name Army
extends Reference

# Represents the player army or any neutral army

var stacks: Dictionary # [int: Stack]


func _init(s: Dictionary):
	stacks = s


func serialized() -> Dictionary:
	var all = {}
	for pos in stacks:
		all[pos] = stacks[pos].serialized()
	return all

func deserialize(data: Dictionary) -> Army:
	var all = {}
	for pos in data:
		var stack = Stack.new("", 0).deserialize(data[pos])
		all[int(pos)] = stack
	stacks = all
	return self
