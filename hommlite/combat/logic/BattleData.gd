class_name BattleData
extends Node

signal _battle_data_state_changed

# Represents all the units in the battlefield
# from a game perspective, not UI

var _grid: BattleGrid
var _logger: BattleLogger

# original army (data)
var _battle_data: BattleSetup

# current battle field stacks
var _stacks: Dictionary # [BattleCoords.index: BattleStack]
var _obstacles: Dictionary # [BattleCoords.index: ObstacleData]

enum State {
	IN_PROGRESS,
	WAITING_FOR_UI,
	COMBAT_ENDED
}
var _state: int = State.IN_PROGRESS setget update_state, get_state


func setup(grid: BattleGrid, logger: BattleLogger, setup_data: BattleSetup):
	_grid = grid
	_logger = logger
	_battle_data = setup_data
	
	var stack_id = 1
	stack_id = _setup_stacks(setup_data.left_army, BattleStack.Side.LEFT, stack_id)
	stack_id = _setup_stacks(setup_data.right_army, BattleStack.Side.RIGHT, stack_id)
	_setup_obstacles(setup_data.obstacles)


func all_stacks() -> Array:
	return _stacks.values()

func all_obstacles() -> Array:
	return _obstacles.values()

func get_stack_at(coords: BattleCoords) -> BattleStack:
	if _stacks.has(coords.index):
		return _stacks.get(coords.index)
	elif _stacks.has(coords.index - 1):
		var possible_target = _stacks.get(coords.index - 1)
		if possible_target and possible_target.stack.unit.large:
			return possible_target
	return null



func move_stack(stack: BattleStack, new_coords: BattleCoords):
	_stacks.erase(stack.coordinates.index)
	_stacks[new_coords.index] = stack
	stack.coordinates = new_coords


func attack_stack(source: BattleStack, target: BattleStack, ranged: bool) -> bool:
	var dmg = source.damage_roll(target, ranged)
	var initial_size = target.amount
	
	target.apply_damage(dmg)
	_logger.log_attack(source, target, dmg, initial_size - target.amount)
	if target.amount > 0:
		return false
	else:
		_stacks.erase(target.coordinates.index)
		return true


func can_reach(stack: BattleStack, target: BattleCoords) -> bool:
	return _array_contains_coords(reachable_coords(stack), target)


func can_attack(source: BattleStack, target: BattleStack) -> bool:
	var all_coords = _reachability(source, source.stack.unit.speed + 1, target.all_taken_coordinates())
	return _array_contains_coords(all_coords, target.coordinates)


func can_attack_ranged(stack: BattleStack) -> bool:
	if stack.stack.unit.ranged:
		var neighbors = _grid.valid_neighbors(stack.coordinates)
		for coords in neighbors:
			if _stacks.has(coords.index) and _stacks[coords.index].side != stack.side:
				return false
		return true
	else:
		return false


func reachable_coords(stack: BattleStack) -> Array: # [BattleCoords]
	return _reachability(stack, stack.stack.unit.speed, stack.all_taken_coordinates())


func get_state():
	return _state

func update_state(new_value):
	if _state != new_value:
		_state = new_value
		emit_signal("_battle_data_state_changed")


func force_state_update():
	emit_signal("_battle_data_state_changed")


func path_find(source: BattleStack, target: BattleCoords) -> Array: # [BattleCoords]
	var all_coords = _reachability(source, source.stack.unit.speed + 1, [target])
	return _grid.path_find(source, target, all_coords)


func _reachability(source: BattleStack, distance: int, excluded: Array) -> Array:
	var flying = source.stack.unit.flying
	var blocked_index = _blocked_coords_indexed(source)
	for excluded_coord in excluded:
		blocked_index.erase(excluded_coord.index)
	var blocked_coords = blocked_index.values() if !flying else []
	
	var coords = _grid.reachable_valid_coords(source.coordinates, distance, blocked_coords)
	
	if flying:
		coords = _remove_blocked_coords(coords, blocked_index)
	if source.stack.unit.large:
		coords = _remove_single_spaces(coords)
	return coords


func _blocked_coords_indexed(source: BattleStack) -> Dictionary:
	var blocked_coords = {}
	
	for stack in _stacks.values():
		blocked_coords[stack.coordinates.index] = stack.coordinates
		if stack.stack.unit.large:
			var second_coords = BattleCoords.new(stack.coordinates.x + 1, stack.coordinates.y)
			blocked_coords[second_coords.index] = second_coords
	for obstacle in _obstacles.values():
		blocked_coords[obstacle.coordinates.index] = obstacle.coordinates
	
	return blocked_coords

func _remove_blocked_coords(all_coords: Array, blocked_index: Dictionary) -> Array:
	var fixed_coords = []
	for coord in all_coords:
		if !blocked_index.has(coord.index):
			fixed_coords.append(coord)
	return fixed_coords

func _remove_single_spaces(coords: Array) -> Array:
	var index = {}
	for coord in coords:
		index[coord.index] = coord
	for coord in coords:
		if !index.has(coord.index - 1) and !index.has(coord.index + 1):
			index.erase(coord.index)
	return index.values()


func _array_contains_coords(array: Array, coords: BattleCoords) -> bool:
	for coord in array:
		if coord.index == coords.index:
			return true
	return false


func _setup_stacks(army: ArmyData, side: int, stack_id: int) -> int:
	var army_size = army.stacks.size()
	for i in range(army_size):
		var stack = army.stacks[i]
		var coords = _stack_coordinates(army_size, i, side, stack.unit)
		
		_stacks[coords.index] = BattleStack.new(stack_id, stack, coords, side)
		stack_id += 1
	return stack_id


func _stack_coordinates(army_size: int, position: int, side: int, unit: UnitData) -> BattleCoords:
	var right = side == BattleStack.Side.RIGHT
	var y = position + (_grid.rows - army_size) / 2
	var x = 0 if !right else (_grid.cols - 1 if y % 2 else _grid.cols)
	
	if right and unit.large:
		x -= 1
	return BattleCoords.new(x, y)


func _setup_obstacles(obstacles: Array):
	_obstacles = {}
	for o in obstacles:
		_obstacles[o.coordinates.index] = o
