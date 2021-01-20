class_name AIController
extends Node

var _grid: BattleGrid
var _data: BattleData
var _manager: BattleManager

func setup(grid: BattleGrid, data: BattleData, manager: BattleManager):
	_grid = grid
	_data = data
	_manager = manager


func _on_Battle_game_state_changed(battle):
	match battle.get_state():
		BattleData.State.AI_TURN:
			_play(battle.get_active_stack())


func _play(active: BattleStack):
	var options = [
		funcref(self, "_try_ranged_attack"),
		funcref(self, "_try_melee_attack"),
		funcref(self, "_try_move_attack"),
		funcref(self, "_try_move"),
	]
	
	for option in options:
		if option.call_func(active):
			return
	_manager.perform_skip()


# Actions

func _try_ranged_attack(active: BattleStack) -> bool:
	if active.stack.unit.ranged and _data.can_attack_ranged(active):
		_manager.perform_ranged_attack(_best_ranged_target(active))
		return true
	return false


func _try_melee_attack(active: BattleStack) -> bool:
	var neighbors = _data.stack_valid_neighbors(active)
	var target = _best_enemy_in_range(neighbors)
	if target:
		_manager.perform_attack(target, active.coordinates)
		return true
	return false


func _try_move_attack(active: BattleStack) -> bool:
	var reachable = _data.reachable_coords(active)
	for stack in _data.all_stacks():
		if stack.side == BattleStack.Side.LEFT and _data.can_attack(active, stack):
			var target_coords = _closest_free_space_next_to(stack, active)
			if target_coords:
				_manager.perform_attack(stack, target_coords)
				return true
	return false


func _try_move(active: BattleStack) -> bool:
	return false

# Utils

func _best_ranged_target(active: BattleStack) -> BattleStack:
	# TODO: sort by score
	for stack in _data.all_stacks():
		if stack.side == BattleStack.Side.LEFT:
			return stack
	return null


func _best_enemy_in_range(all_coords: Array) -> BattleStack:
	# TODO: sort by score
	for coords in all_coords:
		var stack = _data.get_stack_at(coords)
		if stack and stack.side == BattleStack.Side.LEFT:
			return stack
	return null


func _closest_free_space_next_to(target: BattleStack, origin: BattleStack) -> BattleCoords:
	var neighbors = _data.stack_empty_neighbors(target)
	# TODO: closest instead of any
	# TODO: handle large sizes
	for coords in neighbors:
		if _data.can_reach(origin, coords):
			return coords
	return null
