extends Node2D

export(Color) var hover_color

var battle: Battle
var hexgrid: HexGrid

var _hovered_cell


func setup(_battle: Battle, _hexgrid: HexGrid):
	battle = _battle
	hexgrid = _hexgrid


func _draw():
	if _hovered_cell != null:
		draw_polygon(_hovered_cell.points, [hover_color])


func _on_UI_hex_grid_hovered(coords: BattleCoords):
	if coords != null:
		var active_stack = battle.queue.get_active_stack()
		var targetted_stack = battle.state.get_stack_at(coords)
		var cell = hexgrid.get_cell_at_coords(coords)
		
		if targetted_stack != null:
			if targetted_stack.side != active_stack.side and battle.state.can_attack(active_stack, targetted_stack):
				_hovered_cell = _closest_reachable_cell(targetted_stack)
			else:
				_hovered_cell = null
		else:
			if battle.state.can_reach(active_stack, coords):
				_hovered_cell = cell
			else:
				_hovered_cell = null
	else:
		_hovered_cell = null
	update()


func _closest_reachable_cell(target: BattleStack) -> HexCell:
	var active_stack = battle.queue.get_active_stack()
	var mouse_pos = get_local_mouse_position()
	var target_pos = hexgrid.get_cell_at_coords(target.coordinates).center
	var neighbors = battle.grid.valid_neighbors(target.coordinates)
	
	# TODO: this is wasteful
	_sort_closest_target = mouse_pos
	neighbors.sort_custom(self, "_sort_closest")
	
	for coords in neighbors:
		if battle.state.can_reach(active_stack, coords):
			return hexgrid.get_cell_at_coords(coords)
	
	return null


var _sort_closest_target: Vector2
func _sort_closest(a: BattleCoords, b: BattleCoords) -> bool:
	var a_pos = hexgrid.get_cell_at_coords(a).center
	var b_pos = hexgrid.get_cell_at_coords(b).center
	var a_dist = abs(a_pos.distance_to(_sort_closest_target))
	var b_dist = abs(b_pos.distance_to(_sort_closest_target))
	
	return a_dist < b_dist
