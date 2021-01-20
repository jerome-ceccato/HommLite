class_name AIController
extends Node

var _grid: BattleGrid
var _data: BattleData
var _manager: BattleManager

func setup(grid: BattleGrid, data: BattleData, manager: BattleManager):
	_grid = grid
	_data = data
	_manager = manager


func _play(active: BattleStack):
	_manager.perform_skip()


func _on_Battle_game_state_changed(battle):
	match battle.get_state():
		BattleData.State.AI_TURN:
			_play(battle.get_active_stack())
