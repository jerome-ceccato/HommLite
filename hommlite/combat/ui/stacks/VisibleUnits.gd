extends Node2D

var battle: Battle
var containers: Array # [StackContainer]

var active_container: StackContainer


func setup_units(battle: Battle):
	self.battle = battle
	
	containers = []
	for battle_stack in battle.all_stacks():
		containers.append(_load_sprite(battle_stack))


func reposition(grid: HexGrid):
	for container in containers:
		container.position = grid.get_cell_at_coords(container.stack.coordinates).center


func move_stack(grid: HexGrid, stack: BattleStack, movement: BattleMovement) -> float:
	var container = _container_for_bstack(stack)
	if container != null:
		var path_coords = _points_for_path(movement.path, grid)
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


func _on_Battle_game_state_changed(battle: Battle):
	match battle.get_state():
		BattleData.State.IN_PROGRESS:
			_update_active_stack(battle.get_active_stack())
		BattleData.State.WAITING_FOR_UI:
			_update_active_stack(null)
		BattleData.State.COMBAT_ENDED:
			if active_container != null:
				active_container.set_active(false)
				active_container = null


func _update_active_stack(battle_stack: BattleStack):
	if active_container != null:
		active_container.set_active(false)
		active_container = null
	
	var container = _container_for_bstack(battle_stack) if  battle_stack else null
	if container != null:
		container.set_active(true)
		active_container = container


func _load_sprite(battle_stack: BattleStack) -> StackContainer:
	var scene = _scene_for_unit(battle_stack.stack.unit)
	var main_node = scene.instance()
	
	var container: StackContainer = main_node.get_child(0)
	main_node.remove_child(container)
	add_child(container)
	
	container.setup_with_stack(battle_stack)
	return container


func _container_for_bstack(bstack: BattleStack) -> StackContainer:
	for item in containers:
		if item.stack.id == bstack.id:
			return item
	return null


func _points_for_path(coords: Array, grid: HexGrid) -> Array:
	var items = []
	for c in coords:
		items.append(grid.get_cell_at_coords(c).center)
	items.remove(0) # first coord is always the current one
	return items


func _scene_for_unit(unit: UnitData) -> PackedScene:
	var scene_id = "res://combat/ui/stacks/units/%s.tscn" % unit.id
	return load(scene_id) as PackedScene
