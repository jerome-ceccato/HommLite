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


func move_stack(grid: HexGrid, stack: BattleStack, movement: BattleMovement) -> float:
	var container = _container_for_bstack(stack)
	if container != null:
		var path_coords = _hex_centers_for_coords(movement.path, grid)
		container.animate_through_points(path_coords, movement.flying)
		return container.animation_time(path_coords)
	return 0.0


func remove_stack(grid: HexGrid, stack: BattleStack) -> float:
	var container = _container_for_bstack(stack)
	if container != null:
		return container.animate_death()
	return 0.0


func refresh_stack(grid: HexGrid, stack: BattleStack) -> float:
	var container = _container_for_bstack(stack)
	if container != null:
		return container.animate_refresh()
	return 0.0


func _on_Battle_game_ended(winner_side: bool):
	if active_container != null:
		active_container.set_active(false)
		active_container = null


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
	var scene = load("res://combat/ui/stacks/units/stack.tscn")
	var container: StackContainer = scene.instance()
	add_child(container)
	container.setup_with_stack(battle_stack)
	return container


func _container_for_bstack(bstack: BattleStack) -> StackContainer:
	for item in containers:
		if item.stack.id == bstack.id:
			return item
	return null


func _hex_centers_for_coords(coords: Array, grid: HexGrid) -> Array:
	var items = []
	for c in coords:
		items.append(grid.get_cell_at_coords(c).center)
	return items
