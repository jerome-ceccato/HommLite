class_name BattleStack
extends Reference

# A stack during a battle

var id: int # unique id to track the stack throughout the battle
var stack: StackData
var coordinates: BattleCoords
var side: int

const Side = {UNKNOWN = 0, LEFT = 1, RIGHT = 2}

# in battle stats

var amount: int
var top_unit_hp: int
var can_retaliate: bool = true


func _init(_id: int, s: StackData, c: BattleCoords, si: int):
	id = _id
	stack = s
	coordinates = c
	side = si
	
	amount = s.amount
	top_unit_hp = s.unit.hp


func all_taken_coordinates() -> Array:
	if stack.unit.large:
		return [coordinates, BattleCoords.new(coordinates.x + 1, coordinates.y)]
	else:
		return [coordinates]


func all_neighbors(grid) -> Array:
	var neighbors_index = {}
	for coords in all_taken_coordinates():
		for n in grid.valid_neighbors(coords):
			neighbors_index[n.index] = n
	for coords in all_taken_coordinates():
		neighbors_index.erase(coords.index)
	return neighbors_index.values()


func damage_roll(target: BattleStack, ranged: bool) -> int:
	if amount == 0:
		return 0
	
	var dmin = stack.unit.dmg_low * amount
	var dmax = stack.unit.dmg_high * amount
	
	# Base damage roll (dmg * stack)
	var base_roll: int
	if dmin == dmax:
		base_roll = dmin
	else:
		base_roll = dmin + (randi() % (dmax - dmin + 1))
	
	# Attack - Defence multiplier
	var roll: int = base_roll
	var atk_bonus = stack.unit.atk - target.stack.unit.def
	if atk_bonus > 0:
		var multiplier = min(1 + 0.05 * atk_bonus, 3)
		roll = floor(float(roll) * multiplier)
	elif atk_bonus < 0:
		var multiplier = max(1 + 0.025 * atk_bonus, 0.3)
		roll = floor(float(roll) * multiplier)
	
	# Melee penalty multiplier
	if !ranged and stack.unit.ranged:
		roll /= 2
	
	return int(max(1, roll))


func apply_damage(dmg: int):
	if top_unit_hp > dmg:
		top_unit_hp -= dmg
	else:
		dmg -= top_unit_hp
		
		var dmg_stacks = 1 + dmg / stack.unit.hp
		var dmg_remaining = dmg % stack.unit.hp
		
		amount = max(0, amount - dmg_stacks)
		top_unit_hp = dmg_remaining if dmg_remaining > 0 else stack.unit.hp
