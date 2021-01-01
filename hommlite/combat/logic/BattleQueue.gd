extends Node

signal active_stack_changed(stack) # BattleStack
signal stack_moved(stack)

# Represents the turn order during the battle
class_name BattleQueue

var battle: Battle
var queue: Array

func setup(_battle: Battle):
	battle = _battle
	queue = battle.all_stacks()

func run():
	emit_signal("active_stack_changed", queue[0])

func _on_Grid_hex_cell_clicked(coords: BattleCoords):
	var stack = battle.get_stack_at(coords)
	if stack == null:
		var active_stack = queue[0]
		if _can_reach(active_stack, coords):
			battle.move_stack(active_stack, coords)
			emit_signal("stack_moved", active_stack)

func _can_reach(stack: BattleStack, target: BattleCoords) -> bool:
	var stack_movement_coords = battle.battle_grid.nearby_valid_coords(stack.coordinates, stack.stack.unit.speed)
	for coord in stack_movement_coords:
		if coord.index == target.index:
			return true
	return false
