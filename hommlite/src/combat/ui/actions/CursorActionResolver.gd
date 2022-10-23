class_name CursorActionResolver
extends Node

var battle: Battle
var hexgrid: CombatHexGrid


func setup(_battle: Battle, _hexgrid: CombatHexGrid):
	battle = _battle
	hexgrid = _hexgrid


func get_state(mouse_pos: Vector2) -> CursorState:
	var state = CursorState.new()
	state.mouse_pos = mouse_pos
	var coords = hexgrid.get_cell_coords_at_point(mouse_pos)
	state.hovered_cell_coords = coords
	
	if coords != null:
		state.hover_hex_cells = [hexgrid.get_cell_at_coords(coords)]
		state.active_stack = battle.get_active_stack()
		state.target_stack = battle.get_stack_at_coords(coords)
		
		if state.target_stack != null and !_target_is_large_self(state.active_stack, state.target_stack, coords):
			var is_enemy = state.target_stack.side != state.active_stack.side
			
			if is_enemy and battle.can_attack_ranged(state.active_stack):
				state.action = CursorState.Action.RANGED_REACHABLE_STACK
			else:
				var can_attack = battle.can_attack(state.active_stack, state.target_stack)
				if is_enemy and can_attack:
					state.hover_hex_cells = _closest_reachable_cells(state.target_stack, coords, mouse_pos)
					state.action = CursorState.Action.REACHABLE_STACK
				else:
					state.action = CursorState.Action.UNREACHABLE_STACK
		else:
			if battle.can_reach(state.active_stack, coords):
				state.hover_hex_cells = _hover_cells(state.active_stack, coords, battle.reachable_coords(state.active_stack))
				if !_move_is_identity(state.active_stack, state.hover_hex_cells):
					state.action = CursorState.Action.REACHABLE_CELL
				else:
					state.action = CursorState.Action.UNREACHABLE_CELL
			else:
				state.action = CursorState.Action.UNREACHABLE_CELL
	else:
		state.active_stack = null
		state.target_stack = null
		state.hover_hex_cells = []
		state.action = CursorState.Action.NONE
	
	return state


func _move_is_identity(stack: BattleStack, hover_cells: Array) -> bool:
	var coords = stack.all_taken_coordinates()
	if coords.size() != hover_cells.size():
		return false
	
	var coords_index = {}
	for coord in coords:
		coords_index[coord.index] = coord
	
	for cell in hover_cells:
		if !coords_index.has(cell.coords.index):
			return false
	return true


func _target_is_large_self(active: BattleStack, target: BattleStack, cursor: BattleCoords) -> bool:
	if active.id == target.id:
		return active.unit.large and cursor.index != active.coordinates.index
	return false


func _hover_cells(active: BattleStack, cursor_coords: BattleCoords, available_coords: Array) -> Array:
	if active.unit.large:
		var coords = [hexgrid.get_cell_at_coords(cursor_coords)]
		var available_index = {}
		for coord in available_coords:
			available_index[coord.index] = coord
		var next = BattleCoords.new(cursor_coords.x + 1, cursor_coords.y)
		var previous = BattleCoords.new(cursor_coords.x - 1, cursor_coords.y)
		
		if available_index.has(next.index):
			coords.append(hexgrid.get_cell_at_coords(next))
		elif available_index.has(previous.index):
			coords.insert(0, hexgrid.get_cell_at_coords(previous))
		return coords
	else:
		return [hexgrid.get_cell_at_coords(cursor_coords)]


func _closest_reachable_cells(_target: BattleStack, target_coords: BattleCoords, mouse: Vector2) -> Array:
	var active_stack = battle.get_active_stack()
	var neighbors = battle.get_grid().valid_neighbors(target_coords)
	
	# TODO: this is wasteful
	_sort_mouse_pos = mouse
	neighbors.sort_custom(Callable(self,"_sort_closest"))
	for coords in neighbors:
		if _coords_in_stack(coords, active_stack) or battle.can_reach(active_stack, coords):
			var cells = [hexgrid.get_cell_at_coords(coords)]
			if active_stack.unit.large:
				var distance = hexgrid.get_cell_at_coords(target_coords).center.x - mouse.x
				var offset = -1
				if coords.y != target_coords.y:
					if distance < -10:
						offset = 1
				var next_coords = BattleCoords.new(coords.x + offset, coords.y)
				if battle.can_reach(active_stack, next_coords):
					cells.insert(0 if offset < 0 else 1, hexgrid.get_cell_at_coords(next_coords))
				else:
					var previous_coords = BattleCoords.new(coords.x - offset, coords.y)
					if battle.can_reach(active_stack, previous_coords):
						cells.insert(0 if offset > 0 else 1, hexgrid.get_cell_at_coords(previous_coords))
			return cells
	
	return []


func _coords_in_stack(coords: BattleCoords, stack: BattleStack) -> bool:
	for c in stack.all_taken_coordinates():
		if coords.index == c.index:
			return true
	return false


var _sort_mouse_pos: Vector2
func _sort_closest(a: BattleCoords, b: BattleCoords) -> bool:
	var a_pos = hexgrid.get_cell_at_coords(a).center
	var b_pos = hexgrid.get_cell_at_coords(b).center
	var a_dist = abs(a_pos.distance_to(_sort_mouse_pos))
	var b_dist = abs(b_pos.distance_to(_sort_mouse_pos))
	
	return a_dist < b_dist
