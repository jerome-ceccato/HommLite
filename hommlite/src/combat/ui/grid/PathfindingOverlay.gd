extends Node2D

export(Color) var path_color

var battle: Battle
var hexgrid: CombatHexGrid

var _hovered_path


func setup(_battle: Battle, _hexgrid: CombatHexGrid):
	battle = _battle
	hexgrid = _hexgrid


func _draw():
	if battle.get_state() == BattleData.State.PLAYER_TURN:
		if _hovered_path != null:
			for coords in _hovered_path:
				var cell = hexgrid.get_cell_at_coords(coords)
				draw_polygon(cell.make_points_size(12), [path_color])


func _on_UI_mouse_moved(state: CursorState):
	match state.action:
		CursorState.Action.REACHABLE_CELL, CursorState.Action.REACHABLE_STACK, CursorState.Action.RANGED_REACHABLE_STACK:
			var cells = state.hover_hex_cells
			if cells.size() > 0:
				_hovered_path = battle._data.path_find(state.active_stack, cells[0].coords)
			else:
				_hovered_path = []
	update()


func _on_Battle_game_state_changed(_unused: Battle):
	update()
