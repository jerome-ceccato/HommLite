extends Node2D

var battle: Battle
var stacks: Array # [VisualStack]

var active_stack: VisualStack
var active_unit_shader: ShaderMaterial


func _ready():
	var shader = ShaderMaterial.new()
	shader.shader = load("res://assets/combat/active_outline.shader")
	shader.set_shader_param("width", 2.0)
	shader.set_shader_param("outline_color", Color.yellow)
	active_unit_shader = shader


func setup_units(battle: Battle):
	self.battle = battle
	
	stacks = []
	for battle_stack in battle.state.all_stacks():
		stacks.append(_create_sprite(battle_stack))


func reposition(grid: HexGrid):
	for sprite in stacks:
		sprite.position = grid.get_cell_at_coords(sprite.stack.coordinates).center


func move_stack(grid: HexGrid, stack: BattleStack) -> float:
	for sprite in stacks:
		if sprite.stack.id == stack.id:
			_move_animated(sprite, grid.get_cell_at_coords(stack.coordinates).center)
	return 0.5


func remove_stack(grid: HexGrid, stack: BattleStack) -> float:
	for sprite in stacks:
		if sprite.stack.id == stack.id:
			sprite.visible = false
	return 0.001


func _move_animated(sprite: VisualStack, destination: Vector2):
	var tween = Tween.new()
	add_child(tween)
	
	var _property = "position"
	var _initial_value = sprite.position
	var _final_value = destination
	var _duration = 0.5 # in seconds
	var _transition_type = Tween.TRANS_SINE
	var _ease_type = Tween.EASE_IN_OUT
	tween.interpolate_property(
		sprite,
		_property,
		_initial_value,
		_final_value,
		_duration,
		_transition_type,
		_ease_type
	)
	tween.start()

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
	vstack.scale = Vector2(3,3)
	vstack.offset = Vector2(0,0)
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
