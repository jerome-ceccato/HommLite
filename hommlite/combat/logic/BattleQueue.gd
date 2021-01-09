class_name BattleQueue
extends Node

# Represents the turn order during the battle

var _data: BattleData

var _queue: Array # [BattleStack]
var _q_index := 0


func setup(data: BattleData):
	_data = data
	
	_queue = _data.all_stacks()
	_queue.sort_custom(self, "sort_stacks")


func get_active_stack() -> BattleStack:
	return _queue[_q_index]


func stack_is_active(stack: BattleStack) -> bool:
	return stack.id == _queue[_q_index].id


func next():
	_q_index = _q_index + 1 if _q_index + 1 < _queue.size() else 0


func remove_stack_from_queue(stack: BattleStack):
	var index = _queue.find(stack)
	if index >= 0:
		_queue.remove(index)
		if index <= _q_index:
			_q_index -= 1
