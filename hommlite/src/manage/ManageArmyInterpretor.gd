class_name ManageArmyInterpretor
extends Node

var _output: RichTextLabel


func setup(output: RichTextLabel):
	_output = output
	output.clear()


func _help():
	_output.text += """Commands:
- help: Show this message
- move {from} {to} [{amount}]: Moves troops from one slot to another
"""
	pass
	
func _move(from: int, to: int, amount: int) -> bool:
	var stacks = Context.save_data.hero.army.stacks
	var hasAmount = amount >= 0
	
	if from >= 6 or to >= 6 or from < 0 or to < 0:
		return false
	
	if stacks.has(from):
		if !hasAmount:
			amount = stacks[from].amount
		amount = min(amount, stacks[from].amount)
		if stacks.has(to):
			if stacks[from].unit_reference == stacks[to].unit_reference: # Move units between similar stacks
				stacks[to].amount += amount
				stacks[from].amount -= amount
				if stacks[from].amount <= 0:
					stacks.erase(from)
			elif !hasAmount: # Swap 2 units 
				var fromStack = stacks[from]
				stacks[from] = stacks[to]
				stacks[to] = fromStack
			else:
				return false
		else:
			if amount < stacks[from].amount: # Split stack into empty space
				var newStack = Stack.new(stacks[from].unit_reference, amount)
				stacks[from].amount -= amount
				stacks[to] = newStack
			else: # Move stack to empty space
				stacks[to] = stacks[from]
				stacks.erase(from)
	else:
		return false
	return true

func handle(command: String) -> bool:
	var tokens = command.split(' ', false)
	
	if tokens.size() > 0:
		match tokens[0].to_lower():
			"help", "?":
				_help()
			"move":
				if tokens.size() >= 3:
					if _move(int(tokens[1]), int(tokens[2]), (int(tokens[3]) if tokens.size() > 3 else -1)):
						_output.text += "Moved troops!\n"
						return true
					else:
						_output.text += "Invalid move arguments\n"
						return false
				else:
					_output.text += "Invalid command: %s\n" % tokens[0]
					return false
			_:
				_output.text += "Unknown command: %s\n" % tokens[0]
				return false
		return true
	return false
