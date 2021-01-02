extends Node

signal active_stack_changed(stack) # BattleStack
signal stack_moved(stack)

# Represents the turn order during the battle
class_name BattleQueue

var _battle_state: BattleState
var _grid: BattleGrid

var _queue: Array
var _q_index := 0

func setup(battle_state: BattleState, grid: BattleGrid):
	_battle_state = battle_state
	_grid = grid
	_queue = _battle_state.all_stacks()
	_queue.sort_custom(self, "sort_stacks")

func run():
	emit_signal("active_stack_changed", _queue[_q_index])

func stack_is_active(stack: BattleStack) -> bool:
	return stack.id == _queue[_q_index].id

func _queue_next():
	_q_index = _q_index + 1 if _q_index + 1 < _queue.size() else 0
	emit_signal("active_stack_changed", _queue[_q_index])

func _on_Grid_hex_cell_clicked(coords: BattleCoords):
	var stack = _battle_state.get_stack_at(coords)
	if stack == null:
		var active_stack = _queue[_q_index]
		if _can_reach(active_stack, coords):
			_battle_state.move_stack(active_stack, coords)
			emit_signal("stack_moved", active_stack)
			_queue_next()

func _can_reach(stack: BattleStack, target: BattleCoords) -> bool:
	var stack_movement_coords = _grid.nearby_valid_coords(stack.coordinates, stack.stack.unit.speed)
	for coord in stack_movement_coords:
		if coord.index == target.index:
			return true
	return false

func sort_stacks(a: BattleStack, b: BattleStack) -> bool:
	if a.stack.unit.initiative != b.stack.unit.initiative:
		return a.stack.unit.initiative > b.stack.unit.initiative
	return a.id < b.id
