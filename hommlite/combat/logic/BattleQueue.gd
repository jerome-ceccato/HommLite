class_name BattleQueue
extends Node

# Represents the turn order during the battle

var _battle_state: BattleState
var _grid: BattleGrid
var _events: BattleEvents

var _queue: Array # [BattleStack]
var _q_index := 0


func setup(battle_state: BattleState, grid: BattleGrid, events: BattleEvents):
	_battle_state = battle_state
	_grid = grid
	_events = events
	
	_queue = _battle_state.all_stacks()
	_queue.sort_custom(self, "sort_stacks")


func run():
	_events.emit_signal("active_stack_changed", _queue[_q_index])


func get_active_stack() -> BattleStack:
	return _queue[_q_index]


func stack_is_active(stack: BattleStack) -> bool:
	return stack.id == _queue[_q_index].id


func _queue_next():
	_q_index = _q_index + 1 if _q_index + 1 < _queue.size() else 0
	_events.emit_signal("active_stack_changed", _queue[_q_index])


func _action_move(coords: BattleCoords):
	var active_stack = _queue[_q_index]
	var previous_pos = active_stack.coordinates
	_battle_state.move_stack(active_stack, coords)
	_events.emit_signal("stack_moved", active_stack, previous_pos)
	yield(_events, "resume")
	_queue_next()


func _action_attack(target: BattleStack, from: BattleCoords):
	var active_stack = _queue[_q_index]
	var previous_pos = active_stack.coordinates
	
	if previous_pos.index != from.index:
		_battle_state.move_stack(active_stack, from)
		_events.emit_signal("stack_moved", active_stack, previous_pos)
		yield(_events, "resume")
	
	# TODO: handle dmg
	_battle_state.attack_stack(active_stack, target)
	_remove_stack_from_queue(target)
	_events.emit_signal("stack_destroyed", target)
	
	_queue_next()


func _remove_stack_from_queue(stack: BattleStack):
	var index = _queue.find(stack)
	if index >= 0:
		_queue.remove(index)
		if index <= _q_index:
			_q_index -= 1


func _on_UI_mouse_clicked(state: CursorState):
	match state.action:
		CursorState.Action.REACHABLE_CELL:
			_action_move(state.hovered_cell_coords)
		CursorState.Action.REACHABLE_STACK:
			_action_attack(state.target_stack, state.hover_hex_cell.coords)


func sort_stacks(a: BattleStack, b: BattleStack) -> bool:
	if a.stack.unit.initiative != b.stack.unit.initiative:
		return a.stack.unit.initiative > b.stack.unit.initiative
	return a.id < b.id
