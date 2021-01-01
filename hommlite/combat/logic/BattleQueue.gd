extends Node

signal active_stack_changed(stack) # BattleStack
signal stack_moved(stack)

# Represents the turn order during the battle
class_name BattleQueue

var _battle_state: BattleState
var _grid: BattleGrid
var _queue: Array

func setup(battle_state: BattleState, grid: BattleGrid):
	_battle_state = battle_state
	_grid = grid
	_queue = _battle_state.all_stacks()

func run():
	emit_signal("active_stack_changed", _queue[0])

func stack_is_active(stack: BattleStack) -> bool:
	return stack.id == _queue[0].id

func _on_Grid_hex_cell_clicked(coords: BattleCoords):
	var stack = _battle_state.get_stack_at(coords)
	if stack == null:
		var active_stack = _queue[0]
		if _can_reach(active_stack, coords):
			_battle_state.move_stack(active_stack, coords)
			emit_signal("stack_moved", active_stack)

func _can_reach(stack: BattleStack, target: BattleCoords) -> bool:
	var stack_movement_coords = _grid.nearby_valid_coords(stack.coordinates, stack.stack.unit.speed)
	for coord in stack_movement_coords:
		if coord.index == target.index:
			return true
	return false
