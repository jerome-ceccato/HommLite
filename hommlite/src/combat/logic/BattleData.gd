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
	COMBAT_NOT_STARTED,
	PLAYER_TURN,
	AI_TURN,
	WAITING_FOR_UI,
	COMBAT_ENDED
}
var _state: int = State.COMBAT_NOT_STARTED setget update_state, get_state


func setup(grid: BattleGrid, logger: BattleLogger, setup_data: BattleSetup):
	_grid = grid
	_logger = logger
	_battle_data = setup_data
	
	var stack_id = 1
	stack_id = _setup_stacks(setup_data.left_army, BattleStack.Side.LEFT, stack_id)
	stack_id = _setup_stacks(setup_data.right_army, BattleStack.Side.RIGHT, stack_id)
	_setup_obstacles(setup_data.map.obstacles)


func all_stacks() -> Array:
	return _stacks.values()

func all_obstacles() -> Array:
	return _obstacles.values()

func get_stack_at(coords: BattleCoords) -> BattleStack:
	if _stacks.has(coords.index):
		return _stacks.get(coords.index)
	elif _stacks.has(coords.index - 1):
		var possible_target = _stacks.get(coords.index - 1)
		if possible_target and possible_target.unit.large:
			return possible_target
	return null


func stack_valid_neighbors(stack: BattleStack) -> Array:
	var neighbors_index = {}
	for coords in stack.all_taken_coordinates():
		for n in _grid.valid_neighbors(coords):
			neighbors_index[n.index] = n
	for coords in stack.all_taken_coordinates():
		neighbors_index.erase(coords.index)
	return neighbors_index.values()

func stack_empty_neighbors(stack: BattleStack) -> Array:
	var empty_neighbors = []
	for neighbor in stack_valid_neighbors(stack):
		if !get_stack_at(neighbor) and !_obstacles.has(neighbor.index):
			empty_neighbors.append(neighbor)
	return empty_neighbors


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
	var reachable_index = {}
	for coords in reachable_coords(source):
		reachable_index[coords.index] = coords
	
	for coords in stack_valid_neighbors(target):
		if reachable_index.has(coords.index):
			return true
	return false


func can_attack_ranged(stack: BattleStack) -> bool:
	if stack.unit.ranged:
		var neighbors = stack_valid_neighbors(stack)
		for coords in neighbors:
			var target = get_stack_at(coords)
			if target and target.side != stack.side:
				return false
		return true
	else:
		return false


func reachable_coords(stack: BattleStack) -> Array: # [BattleCoords]
	return _reachability(stack, stack.unit.speed, stack.all_taken_coordinates())


func get_state():
	return _state

func update_state(new_value):
	if _state != new_value:
		_state = new_value
		emit_signal("_battle_data_state_changed")


func force_state_update():
	emit_signal("_battle_data_state_changed")


func path_find(source: BattleStack, target: BattleCoords) -> Array: # [BattleCoords]
	var excluded = source.all_taken_coordinates()
	excluded.append(target)
	var all_coords = _reachability(source, source.unit.speed + 1, excluded)
	if source.unit.large:
		all_coords = _large_adjusted_path_finding(all_coords)
	return _grid.path_find(source, target, all_coords)

func path_find_ignoring_speed(source: BattleStack, target: BattleCoords) -> Array: # [BattleCoords]
	var excluded = source.all_taken_coordinates()
	excluded.append(target)
	# TODO: this is horrible
	var all_coords = _reachability(source, 100, excluded)
	if source.unit.large:
		all_coords = _large_adjusted_path_finding(all_coords)
	return _grid.path_find(source, target, all_coords)



func _large_adjusted_path_finding(reachable: Array) -> Array:
	var reachable_index = {}
	for coord in reachable:
		reachable_index[coord.index] = coord
	
	var blocked = []
	for coord in reachable:
		if !reachable_index.has(coord.index + 1):
			blocked.append(coord)
	for coord in blocked:
		reachable_index.erase(coord.index)
	
	return reachable_index.values()


func _reachability(source: BattleStack, distance: int, excluded: Array) -> Array:
	var flying = source.unit.flying
	var blocked_index = _blocked_coords_indexed()
	for excluded_coord in excluded:
		blocked_index.erase(excluded_coord.index)
	if !flying and source.unit.large:
		blocked_index = _add_single_spaces_to_blocked(blocked_index)
	var blocked_coords = blocked_index.values() if !flying else []
	
	var coords = _merged_reachable_valid_coords(source, distance, blocked_coords)
	
	if flying:
		coords = _remove_blocked_coords(coords, blocked_index)
	if source.unit.large:
		coords = _remove_single_spaces(coords)
	return coords


func _merged_reachable_valid_coords(source: BattleStack, distance: int, blocked_coords: Array) -> Array:
	if source.all_taken_coordinates().size() == 1:
		return _grid.reachable_valid_coords(source.coordinates, distance, blocked_coords, source.unit.large)
	else:
		var index_coords = {}
		for stack_coord in source.all_taken_coordinates():
			for coord in _grid.reachable_valid_coords(stack_coord, distance, blocked_coords, source.unit.large):
				index_coords[coord.index] = coord
		return index_coords.values()


func _add_single_spaces_to_blocked(blocked_index: Dictionary) -> Dictionary:
	var available_coords = {}
	for coord in _grid.all_valid_coords():
		available_coords[coord.index] = coord
	for coord in available_coords.values():
		if !blocked_index.has(coord.index):
			var previous_coord_blocked = !available_coords.has(coord.index - 1) or blocked_index.has(coord.index - 1)
			var next_coord_blocked = !available_coords.has(coord.index + 1) or blocked_index.has(coord.index + 1)
			if previous_coord_blocked and next_coord_blocked:
				blocked_index[coord.index] = coord
	return blocked_index

func _blocked_coords_indexed() -> Dictionary:
	var blocked_coords = {}
	
	for stack in _stacks.values():
		for coord in stack.all_taken_coordinates():
			blocked_coords[coord.index] = coord
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


func _setup_stacks(army: Army, side: int, stack_id: int) -> int:
	var army_size = army.stacks.size()
	for i in range(army_size):
		var stack = army.stacks[i]
		var new_stack = BattleStack.new(stack_id, stack, null, side)
		var coords = _stack_coordinates(army_size, i, side, new_stack.unit)
		
		new_stack.coordinates = coords
		_stacks[coords.index] = new_stack
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
