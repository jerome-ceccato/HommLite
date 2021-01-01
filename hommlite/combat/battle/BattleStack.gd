extends Reference

# A stack during a battle
class_name BattleStack

var id: int # unique id to track the stack throughout the battle
var stack: UnitStack
var coordinates: BattleCoords
var side: bool

const Side = {LEFT = false, RIGHT = true}

func _init(_id: int, s: UnitStack, c: BattleCoords, si: bool):
	id = _id
	stack = s
	coordinates = c
	side = si
