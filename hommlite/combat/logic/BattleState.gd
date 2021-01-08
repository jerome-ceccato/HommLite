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

var combat_in_progress: bool
var winner: bool

func setup(grid: BattleGrid, left: ArmyData, right: ArmyData):
	_grid = grid
	_left_army = left
	_right_army = right
	
	var stack_id = 1
	stack_id = _setup_stacks(left, false, stack_id)
	stack_id = _setup_stacks(right, true, stack_id)
	_check_winner()


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
	var all_coords = _reachability(source, source.stack.unit.speed + 1, target.coordinates)
	return _array_contains_coords(all_coords, target.coordinates)


func reachable_coords(stack: BattleStack) -> Array: # [BattleCoords]
	return _reachability(stack, stack.stack.unit.speed, null)


func _reachability(source: BattleStack, distance: int, excluded: BattleCoords) -> Array:
	var flying = source.stack.unit.flying
	var blocked_coords = []
	var excluded_index = excluded.index if excluded else -1
	
	if !flying:
		for stack in _stacks.values():
			if stack.coordinates.index != excluded_index:
				blocked_coords.append(stack.coordinates)
	
	var coords = _grid.reachable_valid_coords(source.coordinates, distance, blocked_coords)
	
	if flying:
		var fixed_coords = []
		for coord in coords:
			if !_stacks.has(coord.index) or coord.index == excluded_index:
				fixed_coords.append(coord)
		return fixed_coords
	else:
		return coords


func path_find(source: BattleStack, target: BattleCoords) -> Array: # [BattleCoords]
	var all_coords = _reachability(source, source.stack.unit.speed + 1, target)
	return _grid.path_find(source, target, all_coords)


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


func _check_winner():
	var stacks_count = {
		BattleStack.Side.LEFT: 0,
		BattleStack.Side.RIGHT: 0,
	}
	
	for stack in _stacks.values():
		stacks_count[stack.side] += 1
	
	combat_in_progress = stacks_count[BattleStack.Side.LEFT] > 0 and stacks_count[BattleStack.Side.RIGHT] > 0
	winner = BattleStack.Side.LEFT if stacks_count[BattleStack.Side.LEFT] > 0 else BattleStack.Side.RIGHT
