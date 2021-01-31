class_name Battle
extends Node

# Represents all the units in the battlefield
# from a game perspective, not UI

onready var _events: BattleEvents = $BattleEvents
onready var _data: BattleData = $BattleData
onready var _grid: BattleGrid = $BattleGrid setget ,get_grid
onready var _queue: BattleQueue = $BattleQueue
onready var _manager: BattleManager = $BattleManager
onready var _logger: BattleLogger = $BattleLogger
onready var _ai: AIController = $AIController


func setup_battle(setup_data: BattleSetup):
	_grid.setup(setup_data.map.map_size)
	_logger.setup(_events)
	_data.setup(_grid, _logger, setup_data)
	_queue.setup(_data)
	_manager.setup(_data, _grid, _events, _queue, _logger)
	_ai.setup(_grid, _data, _manager)
	
	_data.connect("_battle_data_state_changed", self, "on_battle_data_state_changed")


func run():
	_manager.run()


func on_battle_data_state_changed():
	_events.emit_signal("game_state_changed", self)


func get_grid() -> BattleGrid:
	return _grid


func get_state() -> int: # BattleData.State
	return _data.get_state()

func get_winner() -> int: # BattleStack.Side
	return _manager.get_winner()


func all_stacks() -> Array: #[BattleStack]
	return _data.all_stacks()

func get_queue_prediction(size: int) -> Array: #[[BattleStack]]
	return _queue.get_queue_prediction(size)

func get_current_round_number() -> int:
	return _queue.turn_count


func all_obstacles() -> Array:
	return _data.all_obstacles()

func get_active_stack() -> BattleStack:
	return _queue.get_active_stack()

func get_stack_at_coords(coords: BattleCoords) -> BattleStack:
	return _data.get_stack_at(coords)


func reachable_coords(stack: BattleStack) -> Array: # [BattleCoords]
	return _data.reachable_coords(stack)

func can_reach(stack: BattleStack, target: BattleCoords) -> bool:
	return _data.can_reach(stack, target)

func can_attack(source: BattleStack, target: BattleStack) -> bool:
	return _data.can_attack(source, target)

func can_attack_ranged(stack: BattleStack) -> bool:
	return _data.can_attack_ranged(stack)
	


func active_stack_can_wait() -> bool:
	return _queue.active_stack_can_wait()
