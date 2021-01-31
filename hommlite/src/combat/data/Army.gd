class_name Army
extends Reference

# Represents one of the two armies in a fight

var stacks: Array # [Stack]


func _init(s: Array):
	stacks = s


func serialized() -> Array:
	var all = []
	for stack in stacks:
		all.append(stack.serialized())
	return all

func deserialize(data: Array) -> Army:
	var all = []
	for d in data:
		var stack = Stack.new("", 0).deserialize(d)
		all.append(stack)
	stacks = all
	return self
