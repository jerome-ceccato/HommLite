class_name Battle
extends Node

# Represents all the units in the battlefield
# from a game perspective, not UI

onready var events: BattleEvents = $BattleEvents
onready var state: BattleState = $BattleState
onready var grid: BattleGrid = $BattleGrid
onready var queue: BattleQueue = $BattleQueue


func setup_battle(left: ArmyData, right: ArmyData):
	state.setup(grid, left, right)
	queue.setup(state, grid, events)
