extends Reference

# A stack during a battle
class_name BattleStack

var stack: UnitStack
var coordinates: BattleCoords
var side: bool

const Side = {LEFT = false, RIGHT = true}

func _init(s: UnitStack, c: BattleCoords, si: bool):
	stack = s
	coordinates = c
	side = si
