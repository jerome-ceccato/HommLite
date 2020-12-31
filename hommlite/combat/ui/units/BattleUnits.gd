extends Node2D

var battle: Battle
var stacks: Array # [VisualStack]

func setup_units(battle: Battle):
	self.battle = battle
	
	stacks = []
	for battle_stack in battle.stacks.values():
		stacks.append(_create_sprite(battle_stack))

func reposition(grid: HexGrid):
	for sprite in stacks:
		sprite.position = grid.get_cell_at_coords(sprite.stack.coordinates).center
	
	var shader = ShaderMaterial.new()
	shader.shader = load("res://assets/combat/aura.shader")
	shader.set_shader_param("aura_width", 0.5)
	shader.set_shader_param("aura_color", Color.yellow)
	stacks[3].material = shader
	
	shader = ShaderMaterial.new()
	shader.shader = load("res://assets/combat/aura.shader")
	shader.set_shader_param("aura_width", 0.5)
	shader.set_shader_param("aura_color", Color.blue)
	stacks[9].material = shader

# internals

func _create_sprite(battle_stack: BattleStack) -> VisualStack:
	var vstack := VisualStack.new()
	vstack.stack = battle_stack
	vstack.texture = _texture_for_unit(battle_stack.stack.unit)
	vstack.flip_h = battle_stack.side
	vstack.scale = Vector2(1.5, 1.5)
	vstack.offset = Vector2(0, -8)
	add_child(vstack)
	return vstack

func _texture_for_unit(unit: Unit):
	# TODO: Add cache
	return load("res://assets/combat/%s.png" % unit.id)
