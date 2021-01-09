class_name Battle
extends Node

# Represents all the units in the battlefield
# from a game perspective, not UI

onready var _events: BattleEvents = $BattleEvents
onready var _data: BattleData = $BattleData
onready var _grid: BattleGrid = $BattleGrid setget ,get_grid
onready var _manager: BattleManager = $BattleManager


func setup_battle(left: ArmyData, right: ArmyData):
	_data.setup(_grid, left, right)
	_manager.setup(_data, _grid, _events)
	
	_data.connect("_battle_data_state_changed", self, "on_battle_data_state_changed")


func run():
	_manager.run()


func on_battle_data_state_changed():
	_events.emit_signal("game_state_changed", self)


func get_grid() -> BattleGrid:
	return _grid


func get_state() -> int: # BattleData.State
	return _data.get_state()


func all_stacks() -> Array: #[BattleStack]
	return _data.all_stacks()

func get_active_stack() -> BattleStack:
	return _manager.get_active_stack()

func get_stack_at_coords(coords: BattleCoords) -> BattleStack:
	return _data.get_stack_at(coords)


func reachable_coords(stack: BattleStack) -> Array: # [BattleCoords]
	return _data.reachable_coords(stack)

func can_reach(stack: BattleStack, target: BattleCoords) -> bool:
	return _data.can_reach(stack, target)

func can_attack(source: BattleStack, target: BattleStack) -> bool:
	return _data.can_attack(source, target)
