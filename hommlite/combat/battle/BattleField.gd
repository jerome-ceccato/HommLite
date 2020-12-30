extends Node

# Represents all the units in the battlefield
# from a game perspective, not UI
class_name BattleField

# editable
export(int) var rows := 9
export(int) var cols := 13

# original army (data)
var left_army: Army
var right_army: Army

# current battle field stacks
var stacks: Dictionary # [BattleCoords.index: BattleStack]

func setup_battle(left: Army, right: Army):
	left_army = left
	right_army = right
	
	setup_stacks(left, false)
	setup_stacks(right, true)

func setup_stacks(army: Army, right: bool):
	for i in range(army.stacks.size()):
		var stack = army.stacks[i]
		var y = i + 1
		var x = 0 if !right else (cols - 1 if y % 2 else cols)
		var coords = BattleCoords.new(x, y)
		
		stacks[coords.index] = BattleStack.new(stack, coords, right)

func size() -> BattleCoords:
	return BattleCoords.new(cols, rows)
