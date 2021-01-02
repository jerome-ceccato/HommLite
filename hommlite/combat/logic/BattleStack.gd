class_name BattleStack
extends Reference

# A stack during a battle

var id: int # unique id to track the stack throughout the battle
var stack: StackData
var coordinates: BattleCoords
var side: bool

const Side = {LEFT = false, RIGHT = true}


func _init(_id: int, s: StackData, c: BattleCoords, si: bool):
	id = _id
	stack = s
	coordinates = c
	side = si
