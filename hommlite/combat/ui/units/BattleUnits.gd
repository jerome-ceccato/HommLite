extends Node2D

var battle: Battle
var stacks: Array # [VisualStack]

func setup_units(battle: Battle):
	self.battle = battle
	
	stacks = []
	for battle_stack in battle.stacks.values():
		stacks.append(create_sprite(battle_stack))

func reposition(grid: HexGrid):
	for sprite in stacks:
		sprite.position = grid.get_cell(sprite.stack.coordinates).center

# internals

func create_sprite(battle_stack: BattleStack) -> VisualStack:
	var vstack := VisualStack.new()
	vstack.stack = battle_stack
	vstack.texture = texture_for_unit(battle_stack.stack.unit)
	vstack.flip_h = battle_stack.side
	vstack.scale = Vector2(1.5, 1.5)
	vstack.offset = Vector2(0, -8)
	add_child(vstack)
	return vstack

func texture_for_unit(unit: Unit):
	# TODO: Add cache
	return load("res://assets/combat/%s.png" % unit.id)
