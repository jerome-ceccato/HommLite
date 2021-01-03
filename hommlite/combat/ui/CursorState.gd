class_name CursorState
extends Reference

enum Action {
	NONE, # not targetting a hex cell
	UNREACHABLE_CELL, # an empty cell that is unreacheable for the active stack
	REACHABLE_CELL, # an empty cell that is reacheable for the active stack
	UNREACHABLE_STACK, # a stack that the active stack cannot attack (ally or unreachable)
	REACHABLE_STACK # an enemy stack that can be attacked
}

var battle: Battle
var hexgrid: HexGrid

var action: int
var mouse_pos: Vector2
var hovered_cell_coords: BattleCoords
var active_stack: BattleStack
var target_stack: BattleStack
var hover_hex_cell: HexCell


func _init(_battle: Battle, _hexgrid: HexGrid):
	battle = _battle
	hexgrid = _hexgrid


func update(_mouse_pos: Vector2):
	mouse_pos = _mouse_pos
	var coords = hexgrid.get_cell_coords_at_point(mouse_pos)
	hovered_cell_coords = coords
	
	if coords != null:
		active_stack = battle.queue.get_active_stack()
		target_stack = battle.state.get_stack_at(coords)
		hover_hex_cell = hexgrid.get_cell_at_coords(coords)
		
		if target_stack != null:
			if target_stack.side != active_stack.side and battle.state.can_attack(active_stack, target_stack):
				hover_hex_cell = _closest_reachable_cell(target_stack)
				action = Action.REACHABLE_STACK
			else:
				action = Action.UNREACHABLE_STACK
		else:
			if battle.state.can_reach(active_stack, coords):
				action = Action.REACHABLE_CELL
			else:
				action = Action.UNREACHABLE_CELL
	else:
		active_stack = null
		target_stack = null
		hover_hex_cell = null
		action = Action.NONE


func _closest_reachable_cell(target: BattleStack) -> HexCell:
	var active_stack = battle.queue.get_active_stack()
	var target_pos = hexgrid.get_cell_at_coords(target.coordinates).center
	var neighbors = battle.grid.valid_neighbors(target.coordinates)
	
	# TODO: this is wasteful
	neighbors.sort_custom(self, "_sort_closest")
	
	for coords in neighbors:
		if battle.state.can_reach(active_stack, coords):
			return hexgrid.get_cell_at_coords(coords)
	
	return null


func _sort_closest(a: BattleCoords, b: BattleCoords) -> bool:
	var a_pos = hexgrid.get_cell_at_coords(a).center
	var b_pos = hexgrid.get_cell_at_coords(b).center
	var a_dist = abs(a_pos.distance_to(mouse_pos))
	var b_dist = abs(b_pos.distance_to(mouse_pos))
	
	return a_dist < b_dist
