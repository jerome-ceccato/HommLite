extends Node2D

var battle: Battle
var stacks: Array # [VisualStack]

var active_stack: VisualStack
var active_unit_shader: ShaderMaterial


func _ready():
	var shader = ShaderMaterial.new()
	shader.shader = load("res://assets/combat/aura.shader")
	shader.set_shader_param("aura_width", 0.5)
	shader.set_shader_param("aura_color", Color.yellow)
	active_unit_shader = shader


func setup_units(battle: Battle):
	self.battle = battle
	
	stacks = []
	for battle_stack in battle.state.all_stacks():
		stacks.append(_create_sprite(battle_stack))


func reposition(grid: HexGrid):
	for sprite in stacks:
		sprite.position = grid.get_cell_at_coords(sprite.stack.coordinates).center


func move_stack(grid: HexGrid, stack: BattleStack):
	for sprite in stacks:
		if sprite.stack.id == stack.id:
			sprite.position = grid.get_cell_at_coords(stack.coordinates).center


func remove_stack(grid: HexGrid, stack: BattleStack):
	for sprite in stacks:
		if sprite.stack.id == stack.id:
			sprite.visible = false


func _on_Battle_active_stack_changed(stack: BattleStack):
	_update_active_stack(stack)


func _update_active_stack(battle_stack: BattleStack):
	if active_stack != null:
		active_stack.material = null
		active_stack = null
	active_stack = _vstack_for_bstack(battle_stack)
	if active_stack != null:
		active_stack.material = active_unit_shader


func _create_sprite(battle_stack: BattleStack) -> VisualStack:
	var vstack := VisualStack.new()
	vstack.stack = battle_stack
	vstack.texture = _texture_for_unit(battle_stack.stack.unit)
	vstack.flip_h = battle_stack.side
	vstack.scale = Vector2(1.5, 1.5)
	vstack.offset = Vector2(0, -8)
	add_child(vstack)
	return vstack


func _texture_for_unit(unit: UnitData):
	# TODO: Add cache
	return load("res://assets/combat/%s.png" % unit.id)


func _vstack_for_bstack(bstack: BattleStack) -> VisualStack:
	for item in stacks:
		if item.stack.id == bstack.id:
			return item
	return null
