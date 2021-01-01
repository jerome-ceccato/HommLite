extends Node

# Represents all the units in the battlefield
# from a game perspective, not UI
class_name Battle

onready var state := $BattleState
onready var grid := $BattleGrid
onready var queue := $BattleQueue

func setup_battle(left: ArmyData, right: ArmyData):
	state.setup(grid, left, right)
	queue.setup(state, grid)
