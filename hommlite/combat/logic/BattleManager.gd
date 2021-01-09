class_name BattleManager
extends Node

# Coordinates the battle

var _data: BattleData
var _grid: BattleGrid
var _events: BattleEvents
var _queue: BattleQueue

func setup(data: BattleData, grid: BattleGrid, events: BattleEvents, queue: BattleQueue):
	_data = data
	_grid = grid
	_events = events
	_queue = queue


func run():
	_data.emit_signal("_battle_data_state_changed")


func get_winner() -> int:
	if _data.get_state() == BattleData.State.COMBAT_ENDED:
		return _data.all_stacks()[0].side
	else:
		return BattleStack.Side.UNKNOWN

func _update_state():
	if _game_should_end():
		_data.update_state(_data.State.COMBAT_ENDED)
	else:
		_queue.next()
		_data.update_state(_data.State.IN_PROGRESS)


func _action_move(coords: BattleCoords):
	var active_stack = _queue.get_active_stack()
	var path = _data.path_find(active_stack, coords)
	var movement = BattleMovement.new(path, active_stack.stack.unit.flying)
	
	_data.move_stack(active_stack, coords)
	
	_data.update_state(_data.State.WAITING_FOR_UI)
	_events.emit_signal("stack_moved", active_stack, movement)
	yield(_events, "resume")

	_update_state()


func _action_attack(target: BattleStack, from: BattleCoords):
	var active_stack = _queue.get_active_stack()
	var previous_pos = active_stack.coordinates
	
	if previous_pos.index != from.index:
		var path = _data.path_find(active_stack, from)
		var movement = BattleMovement.new(path, active_stack.stack.unit.flying)
		
		_data.move_stack(active_stack, from)
		
		_data.update_state(_data.State.WAITING_FOR_UI)
		_events.emit_signal("stack_moved", active_stack, movement)
		yield(_events, "resume")
	
	if _data.attack_stack(active_stack, target):
		_queue.remove_stack_from_queue(target)
		
		_data.update_state(_data.State.WAITING_FOR_UI)
		_events.emit_signal("stack_destroyed", target)
		yield(_events, "resume")
	else:
		_data.update_state(_data.State.WAITING_FOR_UI)
		_events.emit_signal("stack_damaged", target)
		yield(_events, "resume")
	
	_update_state()


func _on_UI_mouse_clicked(state: CursorState):
	if _data.get_state() != _data.State.IN_PROGRESS:
		return
	
	match state.action:
		CursorState.Action.REACHABLE_CELL:
			_action_move(state.hovered_cell_coords)
		CursorState.Action.REACHABLE_STACK:
			_action_attack(state.target_stack, state.hover_hex_cell.coords)


func sort_stacks(a: BattleStack, b: BattleStack) -> bool:
	if a.stack.unit.initiative != b.stack.unit.initiative:
		return a.stack.unit.initiative > b.stack.unit.initiative
	return a.id < b.id


func _game_should_end():
	var stacks_count = {
		BattleStack.Side.LEFT: 0,
		BattleStack.Side.RIGHT: 0,
	}
	
	for stack in _data.all_stacks():
		stacks_count[stack.side] += 1
	
	var in_progress = stacks_count[BattleStack.Side.LEFT] > 0 and stacks_count[BattleStack.Side.RIGHT] > 0
	return !in_progress
