extends Node

signal active_stack_changed(stack) # BattleStack
signal stack_moved(stack)

# Represents the turn order during the battle
class_name BattleQueue

var battle: Battle

func setup(battle: Battle):
	self.battle = battle

func run():
	emit_signal("active_stack_changed", battle.all_stacks()[0])

func _on_Grid_hex_cell_clicked(coords: BattleCoords):
	var stack = battle.get_stack_at(coords)
	if stack == null:
		var active_stack = battle.all_stacks()[0]
		active_stack.coordinates = coords
		emit_signal("stack_moved", active_stack)
