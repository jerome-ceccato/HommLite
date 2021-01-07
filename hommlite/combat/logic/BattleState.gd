class_name BattleState
extends Node

# Represents all the units in the battlefield
# from a game perspective, not UI

var _grid: BattleGrid

# original army (data)
var _left_army: ArmyData
var _right_army: ArmyData

# current battle field stacks
var _stacks: Dictionary # [BattleCoords.index: BattleStack]


func setup(grid: BattleGrid, left: ArmyData, right: ArmyData):
	_grid = grid
	_left_army = left
	_right_army = right
	
	var stack_id = 1
	stack_id = _setup_stacks(left, false, stack_id)
	stack_id = _setup_stacks(right, true, stack_id)


func all_stacks() -> Array:
	return _stacks.values()


func get_stack_at(coords: BattleCoords) -> BattleStack:
	return _stacks.get(coords.index)


func move_stack(stack: BattleStack, new_coords: BattleCoords):
	_stacks.erase(stack.coordinates.index)
	_stacks[new_coords.index] = stack
	stack.coordinates = new_coords


func attack_stack(source: BattleStack, target: BattleStack) -> bool:
	target.apply_damage(source.damage_roll())
	if target.amount > 0:
		return false
	else:
		_stacks.erase(target.coordinates.index)
		return true


func can_reach(stack: BattleStack, target: BattleCoords) -> bool:
	return _array_contains_coords(reachable_coords(stack), target)


func can_attack(source: BattleStack, target: BattleStack) -> bool:
	var blocked_coords = []
	for stack in _stacks.values():
		if stack.id != target.id:
			blocked_coords.append(stack.coordinates)
	
	var all_coords = _grid.reachable_valid_coords(source.coordinates, source.stack.unit.speed + 1, blocked_coords)
	return _array_contains_coords(all_coords, target.coordinates)


func reachable_coords(stack: BattleStack) -> Array: # [BattleCoords]
	var blocked_coords = []
	for stack in _stacks.values():
		blocked_coords.append(stack.coordinates)
	
	return _grid.reachable_valid_coords(stack.coordinates, stack.stack.unit.speed, blocked_coords)


func path_find(source: BattleStack, target: BattleCoords) -> Array: # [BattleCoords]
	var blocked_coords = []
	for stack in _stacks.values():
		if stack.id != source.id:
			blocked_coords.append(stack.coordinates)
	
	return _grid.path_find(source.coordinates, target, blocked_coords)


func _array_contains_coords(array: Array, coords: BattleCoords) -> bool:
	for coord in array:
		if coord.index == coords.index:
			return true
	return false


func _setup_stacks(army: ArmyData, right: bool, stack_id: int) -> int:
	var army_size = army.stacks.size()
	for i in range(army_size):
		var stack = army.stacks[i]
		var coords = _stack_coordinates(army_size, i, right)
		
		_stacks[coords.index] = BattleStack.new(stack_id, stack, coords, right)
		stack_id += 1
	return stack_id


func _stack_coordinates(army_size: int, position: int, right: bool) -> BattleCoords:
	var y = position + (_grid.rows - army_size) / 2
	var x = 0 if !right else (_grid.cols - 1 if y % 2 else _grid.cols)
	return BattleCoords.new(x, y)
