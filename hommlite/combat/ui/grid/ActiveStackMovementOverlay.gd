extends GridOverlayBase

export(Color) var overlayed_color


func draw_cell(cell: HexCell):
	draw_polygon(cell.points, [overlayed_color])


func _on_Battle_game_state_changed(battle: Battle):
	match battle.get_state():
		BattleData.State.PLAYER_TURN:
			update_overlay(battle.get_active_stack())
		_:
			update_overlay(null)
