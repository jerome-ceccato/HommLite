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
