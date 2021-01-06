class_name BattleStack
extends Reference

# A stack during a battle

var id: int # unique id to track the stack throughout the battle
var stack: StackData
var coordinates: BattleCoords
var side: bool

const Side = {LEFT = false, RIGHT = true}

# in battle stats

var amount: int
var top_unit_hp: int


func _init(_id: int, s: StackData, c: BattleCoords, si: bool):
	id = _id
	stack = s
	coordinates = c
	side = si
	
	amount = s.amount
	top_unit_hp = s.unit.hp


func damage_roll() -> int:
	var dmin = stack.unit.attack_low * amount
	var dmax = stack.unit.attack_high * amount
	
	if amount == 0:
		return 0
	elif dmin == dmax:
		return dmin
	else:
		var roll = dmin + (randi() % (dmax - dmin + 1))
		return roll


func apply_damage(dmg: int):
	if top_unit_hp > dmg:
		top_unit_hp -= dmg
	else:
		dmg -= top_unit_hp
		
		var dmg_stacks = 1 + dmg / stack.unit.hp
		var dmg_remaining = dmg % stack.unit.hp
		
		amount = max(0, amount - dmg_stacks)
		top_unit_hp = dmg_remaining if dmg_remaining > 0 else stack.unit.hp
