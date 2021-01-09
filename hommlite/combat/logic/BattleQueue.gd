class_name BattleQueue
extends Node

# Represents the turn order during the battle

var _data: BattleData

var _queue: Array # [BattleStack]
var _q_index := 0
var _first_pass_length: int
var _turn_count := 0

func setup(data: BattleData):
	_data = data
	
	_rebuild_queue()


func get_active_stack() -> BattleStack:
	return _queue[_q_index]


func stack_is_active(stack: BattleStack) -> bool:
	return stack.id == _queue[_q_index].id


func next():
	if _q_index + 1 < _queue.size():
		_q_index += 1
	else:
		_q_index = 0
		_turn_count += 1
		_rebuild_queue()


func active_stack_can_wait() -> bool:
	return _q_index < _first_pass_length


func move_stack_to_second_pass(stack: BattleStack):
	_queue.insert(_first_pass_length, stack)


func remove_stack_from_queue(stack: BattleStack):
	var index = _queue.find(stack)
	if index > _q_index:
		_queue.remove(index)
		_first_pass_length -= 1


func _rebuild_queue():
	_queue = _data.all_stacks()
	_queue.sort_custom(self, "sort_stacks")
	_first_pass_length = _queue.size()


func sort_stacks(a: BattleStack, b: BattleStack) -> bool:
	if a.stack.unit.initiative != b.stack.unit.initiative:
		return a.stack.unit.initiative > b.stack.unit.initiative
	return a.id < b.id
