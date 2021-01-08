extends Node2D

export(Color) var hover_color
export(Color) var path_color

var battle: Battle
var hexgrid: HexGrid

var _hovered_cell
var _hovered_path

func setup(_battle: Battle, _hexgrid: HexGrid):
	battle = _battle
	hexgrid = _hexgrid


func _draw():
	if battle.data.get_state() == BattleData.State.IN_PROGRESS:
		if _hovered_path != null:
			for coords in _hovered_path:
				var cell = hexgrid.get_cell_at_coords(coords)
				draw_polygon(cell.make_points_size(12), [path_color])
		
		if _hovered_cell != null:
			draw_polygon(_hovered_cell.points, [hover_color])


func _on_UI_mouse_moved(state: CursorState):
	match state.action:
		CursorState.Action.NONE, CursorState.Action.UNREACHABLE_CELL, CursorState.Action.UNREACHABLE_STACK:
			_hovered_cell = null
			_hovered_path = null
		CursorState.Action.REACHABLE_CELL, CursorState.Action.REACHABLE_STACK:
			_hovered_cell = state.hover_hex_cell
			_hovered_path = battle.data.path_find(state.active_stack, _hovered_cell.coords)
	update()


func _on_Battle_game_state_changed(battle: Battle):
	update()
