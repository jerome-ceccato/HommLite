class_name BattleManager
extends Node

# Coordinates the battle

var _data: BattleData
var _grid: BattleGrid
var _events: BattleEvents
var _queue: BattleQueue
var _logger: BattleLogger


func setup(data: BattleData, grid: BattleGrid, events: BattleEvents, queue: BattleQueue, logger: BattleLogger):
	_data = data
	_grid = grid
	_events = events
	_queue = queue
	_logger = logger


func run():
	_select_unit_turn_state()
	_data.emit_signal("_battle_data_state_changed")
	_logger.log_round_started(1)


func get_winner() -> int:
	if _data.get_state() == BattleData.State.COMBAT_ENDED:
		return _data.all_stacks()[0].side
	else:
		return BattleStack.Side.UNKNOWN


func _update_state():
	if _game_should_end():
		_data.update_state(_data.State.COMBAT_ENDED)
		_update_context()
		_logger.log_game_ended(get_winner())
	else:
		_queue_next()


func _update_context():
	if get_winner() == BattleStack.Side.LEFT:
		Context.save_data.hero.army = _get_final_player_army()
		Context.finish_battle(true)
	else:
		Context.finish_battle(false)


func _queue_next():
	if _queue.next():
		_logger.log_round_started(_queue.turn_count)
	_select_unit_turn_state()


func _select_unit_turn_state():
	if _queue.get_active_stack().side == BattleStack.Side.LEFT:
		_data.update_state(_data.State.PLAYER_TURN)
	else:
		_data.update_state(_data.State.AI_TURN)


func perform_move(coords: BattleCoords):
	var active_stack = _queue.get_active_stack()
	var path = _data.path_find(active_stack, coords)
	var movement = BattleMovement.new(path, active_stack.unit.flying)
	
	_data.move_stack(active_stack, coords)
	
	_data.update_state(_data.State.WAITING_FOR_UI)
	_events.emit_signal("stack_moved", active_stack, movement)
	yield(_events, "resume")

	_update_state()


func perform_attack(target: BattleStack, from: BattleCoords):
	var active_stack = _queue.get_active_stack()
	var previous_pos = active_stack.coordinates
	
	if previous_pos.index != from.index:
		var path = _data.path_find(active_stack, from)
		var movement = BattleMovement.new(path, active_stack.unit.flying)
		
		_data.move_stack(active_stack, from)
		
		_data.update_state(_data.State.WAITING_FOR_UI)
		_events.emit_signal("stack_moved", active_stack, movement)
		yield(_events, "resume")
	
	var died = _data.attack_stack(active_stack, target, false)
	if died:
		_queue.remove_stack_from_queue(target)
	_data.update_state(_data.State.WAITING_FOR_UI)
	_events.emit_signal("stack_attacked", active_stack, target, false, false)
	yield(_events, "resume")
	
	if !died and target.can_retaliate:
		_data.attack_stack(target, active_stack, false)
		target.can_retaliate = false
		_data.update_state(_data.State.WAITING_FOR_UI)
		_events.emit_signal("stack_attacked", target, active_stack, true, false)
		yield(_events, "resume")
	
	_update_state()


func perform_ranged_attack(target: BattleStack):
	var active_stack = _queue.get_active_stack()
	
	if _data.attack_stack(active_stack, target, true):
		_queue.remove_stack_from_queue(target)
	_data.update_state(_data.State.WAITING_FOR_UI)
	_events.emit_signal("stack_attacked", active_stack, target, false, true)
	yield(_events, "resume")
	
	_update_state()


func _game_should_end():
	var stacks_count = {
		BattleStack.Side.LEFT: 0,
		BattleStack.Side.RIGHT: 0,
	}
	
	for stack in _data.all_stacks():
		stacks_count[stack.side] += 1
	
	var player_turn = stacks_count[BattleStack.Side.LEFT] > 0 and stacks_count[BattleStack.Side.RIGHT] > 0
	return !player_turn


func _on_UI_mouse_clicked(state: CursorState):
	if _data.get_state() != _data.State.PLAYER_TURN:
		return
	
	match state.action:
		CursorState.Action.REACHABLE_CELL:
			perform_move(state.hover_hex_cells[0].coords)
		CursorState.Action.REACHABLE_STACK:
			perform_attack(state.target_stack, state.hover_hex_cells[0].coords)
		CursorState.Action.RANGED_REACHABLE_STACK:
			perform_ranged_attack(state.target_stack)


func _on_UI_action_skip():
	if _data.get_state() != _data.State.PLAYER_TURN:
		return
	perform_skip()


func perform_skip():
	_logger.log_skip(_queue.get_active_stack())
	_queue_next()
	_data.force_state_update()


func _on_UI_action_wait():
	if _data.get_state() != _data.State.PLAYER_TURN:
		return
		
	if _queue.active_stack_can_wait():
		var current_stack = _queue.get_active_stack()
		_queue.move_stack_to_second_pass(current_stack)
		_logger.log_wait(current_stack)
		_queue_next()
		_data.force_state_update()


func _get_final_player_army() -> Army:
	var stacks = {}
	for bstack in _data.all_stacks():
		if bstack.amount > 0 and bstack.side == BattleStack.Side.LEFT:
			stacks[_data.stack_original_pos(bstack.id)] = Stack.new(bstack.unit.id, bstack.amount)
	return Army.new(stacks)
