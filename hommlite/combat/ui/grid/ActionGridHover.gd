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

func _on_UI_mouse_moved(state: CursorState):
	match state.action:
		CursorState.Action.NONE, CursorState.Action.UNREACHABLE_CELL, CursorState.Action.UNREACHABLE_STACK:
			_hovered_cell = null
		CursorState.Action.REACHABLE_CELL, CursorState.Action.REACHABLE_STACK:
			_hovered_cell = state.hover_hex_cell
	update()
