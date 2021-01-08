class_name Battle
extends Node

# Represents all the units in the battlefield
# from a game perspective, not UI

onready var events: BattleEvents = $BattleEvents
onready var data: BattleData = $BattleData
onready var grid: BattleGrid = $BattleGrid
onready var queue: BattleQueue = $BattleQueue


func setup_battle(left: ArmyData, right: ArmyData):
	data.setup(grid, left, right)
	queue.setup(data, grid, events)
	
	data.connect("_battle_data_state_changed", self, "on_battle_data_state_changed")


func on_battle_data_state_changed():
	events.emit_signal("game_state_changed", self)
