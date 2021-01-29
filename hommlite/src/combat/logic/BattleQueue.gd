class_name BattleQueue
extends Node

# Represents the turn order during the battle

var _data: BattleData

var _queue: Array # [BattleStack]
var _q_index := 0
var _first_pass_length: int

var turn_count := 1


func setup(data: BattleData):
	_data = data
	
	_rebuild_queue()


func get_active_stack() -> BattleStack:
	return _queue[_q_index]


func stack_is_active(stack: BattleStack) -> bool:
	return stack.id == _queue[_q_index].id


func next() -> bool:
	if _q_index + 1 < _queue.size():
		_q_index += 1
		return false
	else:
		_q_index = 0
		turn_count += 1
		_rebuild_queue()
		return true


func active_stack_can_wait() -> bool:
	return _q_index < _first_pass_length


func move_stack_to_second_pass(stack: BattleStack):
	_queue.insert(_first_pass_length, stack)


func remove_stack_from_queue(stack: BattleStack):
	var index = _queue.find(stack)
	if index > _q_index:
		_queue.remove(index)
		_first_pass_length -= 1


func get_queue_prediction(size: int) -> Array:
	var prediction = []
	var current_round = []
	var progress = 0
	
	var index = _q_index
	while index < _queue.size() and progress < size:
		current_round.append(_queue[index])
		index += 1
		progress += 1
	prediction.append(current_round)
	
	if progress < size:
		var next_round_queue = _data.all_stacks()
		next_round_queue.sort_custom(self, "sort_stacks")
		while progress < size:
			index = 0
			progress += 1
			current_round = []
			while index < next_round_queue.size() and progress < size:
				current_round.append(next_round_queue[index])
				index += 1
				progress += 1
			prediction.append(current_round)
		
	
	return prediction


func _rebuild_queue():
	_queue = _data.all_stacks()
	_queue.sort_custom(self, "sort_stacks")
	_first_pass_length = _queue.size()
	_reset_stacks()


func _reset_stacks():
	for stack in _queue:
		stack.can_retaliate = true


func sort_stacks(a: BattleStack, b: BattleStack) -> bool:
	if a.stack.unit.initiative != b.stack.unit.initiative:
		return a.stack.unit.initiative > b.stack.unit.initiative
	return a.id < b.id
