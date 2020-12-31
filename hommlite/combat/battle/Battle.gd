extends Node

# Represents all the units in the battlefield
# from a game perspective, not UI
class_name Battle

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
	var army_size = army.stacks.size()
	for i in range(army_size):
		var stack = army.stacks[i]
		var coords = stack_coordinates(army_size, i, right)
		
		stacks[coords.index] = BattleStack.new(stack, coords, right)

func stack_coordinates(army_size: int, position: int, right: bool) -> BattleCoords:
	var y = position + (rows - army_size) / 2
	var x = 0 if !right else (cols - 1 if y % 2 else cols)
	return BattleCoords.new(x, y)

func size() -> BattleCoords:
	return BattleCoords.new(cols, rows)
