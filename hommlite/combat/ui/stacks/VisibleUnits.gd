extends Node2D

var battle: Battle
var containers: Array # [StackContainer]

var active_container: StackContainer


func setup_units(battle: Battle):
	self.battle = battle
	
	containers = []
	for battle_stack in battle.state.all_stacks():
		containers.append(_load_sprite(battle_stack))


func reposition(grid: HexGrid):
	for container in containers:
		container.position = grid.get_cell_at_coords(container.stack.coordinates).center


func move_stack(grid: HexGrid, stack: BattleStack) -> float:
	var container = _container_for_bstack(stack)
	if container != null:
		return container.animate_to_position(grid.get_cell_at_coords(stack.coordinates).center)
	return 0.0


func remove_stack(grid: HexGrid, stack: BattleStack) -> float:
	var container = _container_for_bstack(stack)
	if container != null:
		return container.animate_death()
	return 0.0


func _on_Battle_active_stack_changed(stack: BattleStack):
	_update_active_stack(stack)


func _update_active_stack(battle_stack: BattleStack):
	if active_container != null:
		active_container.set_active(false)
		active_container = null
	
	var container = _container_for_bstack(battle_stack)
	if container != null:
		container.set_active(true)
		active_container = container


func _load_sprite(battle_stack: BattleStack) -> StackContainer:
	var container: StackContainer = _scene_for_unit(battle_stack.stack.unit).instance()
	add_child(container)
	container.setup_with_stack(battle_stack)
	return container


func _scene_for_unit(unit: UnitData):
	return load("res://combat/ui/stacks/units/%s.tscn" % unit.id)


func _container_for_bstack(bstack: BattleStack) -> StackContainer:
	for item in containers:
		if item.stack.id == bstack.id:
			return item
	return null
