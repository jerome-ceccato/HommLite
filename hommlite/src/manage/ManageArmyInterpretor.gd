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
#	var hasAmount = amount >= 0
#	if Context.player_army.stacks.size() > from:
#		if !hasAmount:
#			amount = Context.player_army.stacks[from].amount
#		amount = min(amount, Context.player_army.stacks[from].amount)
#		if Context.player_army.stacks.size() > to:
#			if Context.player_army.stacks[from].unit_reference == Context.player_army.stacks[to].unit_reference:
#				Context.player_army.stacks[to].amount += amount
#				Context.player_army.stacks[from].amount -= amount
#				if Context.player_army.stacks[from].amount <= 0:
#					Context.player_army.stacks.remove(from)
#			elif !hasAmount:
#				var fromStack = Context.player_army.stacks[from]
#				var toStack = Context.player_army.stacks[to]
#				Context.player_army.stacks.remove(from)
#				Context.player_army.stacks.insert(from, toStack)
#				Context.player_army.stacks.remove(to)
#				Context.player_army.stacks.insert(to, fromStack)
#			else:
#				return false
#		else:
#			if amount < Context.player_army.stacks[from].amount:
#				var newStack = Stack.new(Context.player_army.stacks[from].unit_reference, amount)
#				Context.player_army.stacks[from].amount -= amount
#				Context.player_army.stacks.append(newStack)
#			else:
#				var fromStack = Context.player_army.stacks[from]
#				Context.player_army.stacks.remove(from)
#				Context.player_army.stacks.append(fromStack)
#	else:
#		return false
#	return true
	return false

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
