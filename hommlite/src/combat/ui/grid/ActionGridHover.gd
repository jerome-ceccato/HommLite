extends Node2D

@export var hover_color: Color

var battle: Battle
var hexgrid: CombatHexGrid

var _hovered_cells := []


func setup(_battle: Battle, _hexgrid: CombatHexGrid):
	battle = _battle
	hexgrid = _hexgrid


func _draw():
	if battle.get_state() == BattleData.State.PLAYER_TURN:
		for cell in _hovered_cells:
			draw_polygon(cell.points, [hover_color])


func _on_UI_mouse_moved(state: CursorState):
	match state.action:
		CursorState.Action.NONE, CursorState.Action.UNREACHABLE_CELL, CursorState.Action.UNREACHABLE_STACK:
			_hovered_cells = []
		CursorState.Action.REACHABLE_CELL, CursorState.Action.REACHABLE_STACK, CursorState.Action.RANGED_REACHABLE_STACK:
			_hovered_cells = state.hover_hex_cells
	queue_redraw()


func _on_Battle_game_state_changed(_unused: Battle):
	queue_redraw()
