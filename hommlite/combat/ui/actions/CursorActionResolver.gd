class_name CursorActionResolver
extends Node

var battle: Battle
var hexgrid: HexGrid

var _state: CursorState


func setup(_battle: Battle, _hexgrid: HexGrid):
	battle = _battle
	hexgrid = _hexgrid
	_state = CursorState.new()

func _hover_cells(active: BattleStack, cursor_coords: BattleCoords) -> Array:
	if active.stack.unit.large:
		var coords = [hexgrid.get_cell_at_coords(cursor_coords)]
		var next = hexgrid.get_cell_at_coords(BattleCoords.new(cursor_coords.x + 1, cursor_coords.y))
		if next:
			coords.append(next)
		return coords
	else:
		return [hexgrid.get_cell_at_coords(cursor_coords)]

func get_state(mouse_pos: Vector2) -> CursorState:
	_state.mouse_pos = mouse_pos
	var coords = hexgrid.get_cell_coords_at_point(mouse_pos)
	_state.hovered_cell_coords = coords
	
	if coords != null:
		_state.active_stack = battle.get_active_stack()
		_state.target_stack = battle.get_stack_at_coords(coords)
		_state.hover_hex_cells = _hover_cells(_state.active_stack, coords)
		
		if _state.target_stack != null:
			var is_enemy = _state.target_stack.side != _state.active_stack.side
			
			if is_enemy and battle.can_attack_ranged(_state.active_stack):
				_state.action = CursorState.Action.RANGED_REACHABLE_STACK
			else:
				var can_attack = battle.can_attack(_state.active_stack, _state.target_stack)
				if is_enemy and can_attack:
					_state.hover_hex_cells = [_closest_reachable_cell(_state.target_stack)]
					_state.action = CursorState.Action.REACHABLE_STACK
				else:
					_state.action = CursorState.Action.UNREACHABLE_STACK
		else:
			if battle.can_reach(_state.active_stack, coords):
				_state.action = CursorState.Action.REACHABLE_CELL
			else:
				_state.action = CursorState.Action.UNREACHABLE_CELL
	else:
		_state.active_stack = null
		_state.target_stack = null
		_state.hover_hex_cells = []
		_state.action = CursorState.Action.NONE
	
	return _state


func _closest_reachable_cell(target: BattleStack) -> HexCell:
	var active_stack = battle.get_active_stack()
	var neighbors = battle.get_grid().valid_neighbors(target.coordinates)
	if active_stack.stack.unit.large:
		var other_coords = BattleCoords.new(target.coordinates.x + 1, target.coordinates.y)
		var other_neighbors = battle.get_grid().valid_neighbors(other_coords)
		for o_n in other_neighbors:
			neighbors.append(o_n)
	
	# TODO: this is wasteful
	neighbors.sort_custom(self, "_sort_closest")
	for coords in neighbors:
		if coords.index == active_stack.coordinates.index or battle.can_reach(active_stack, coords):
			return hexgrid.get_cell_at_coords(coords)
	
	return null


func _sort_closest(a: BattleCoords, b: BattleCoords) -> bool:
	var a_pos = hexgrid.get_cell_at_coords(a).center
	var b_pos = hexgrid.get_cell_at_coords(b).center
	var a_dist = abs(a_pos.distance_to(_state.mouse_pos))
	var b_dist = abs(b_pos.distance_to(_state.mouse_pos))
	
	return a_dist < b_dist
