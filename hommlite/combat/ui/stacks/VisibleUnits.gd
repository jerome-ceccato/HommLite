extends Node2D

var battle: Battle
var hexgrid: HexGrid

var containers: Array # [StackContainer]
var obstacles: Array # [Sprite]

var active_container: StackContainer


func setup(_hexgrid: HexGrid, _battle: Battle):
	battle = _battle
	hexgrid = _hexgrid
	
	containers = []
	for battle_stack in battle.all_stacks():
		containers.append(_load_sprite(battle_stack))
	
	obstacles = []
	for obstacle in battle.all_obstacles():
		obstacles.append(_load_obstacle(obstacle))


func animate_move_stack(grid: HexGrid, stack: BattleStack, movement: BattleMovement):
	var container = _container_for_bstack(stack)
	if container != null:
		var path_coords = _points_for_path(movement.path, grid)
		var await = container.animate_through_points(path_coords, movement.flying)
		if await is GDScriptFunctionState:
			await = yield(await, "completed")


func animate_handle_attack(_grid: HexGrid, source: BattleStack, target: BattleStack, retaliation: bool, ranged: bool):
	var source_container = _container_for_bstack(source)
	var target_container = _container_for_bstack(target)
	if source_container != null and target_container != null:
		if retaliation:
			yield(get_tree().create_timer(0.2), "timeout")
			
		var await = null
		if ranged:
			await = _animate_projectile(source_container, target_container)
		if await is GDScriptFunctionState:
			await = yield(await, "completed")
		
		await = null
		if target.amount > 0:
			await = target_container.animate_damaged(source_container)
		else:
			await = target_container.animate_death(source_container)
		if await is GDScriptFunctionState:
			await = yield(await, "completed")


func _animate_projectile(source: StackContainer, target: StackContainer):
	var projectile: Projectile = load("res://combat/ui/projectiles/Projectile.tscn").instance()
	add_child(projectile)
	
	var from = hexgrid.get_cell_at_coords(source.stack.coordinates).center
	var to = hexgrid.get_cell_at_coords(target.stack.coordinates).center
	var await = projectile.animate(from, to)
	if await is GDScriptFunctionState:
			await = yield(await, "completed")


func _on_Battle_game_state_changed(_unused: Battle):
	match battle.get_state():
		BattleData.State.PLAYER_TURN:
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
	container.position = hexgrid.get_cell_at_coords(battle_stack.coordinates).center
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


func _load_obstacle(obstacle: ObstacleData) -> Sprite:
	var sprite = Sprite.new()
	sprite.texture = load(obstacle.texture_reference)
	sprite.scale = Vector2(4, 4)
	sprite.position = hexgrid.get_cell_at_coords(obstacle.coordinates).center
	
	add_child(sprite)
	return sprite
