extends GridOverlayBase

@export var overlayed_color: Color


func draw_cell(cell: CombatHexCell):
	draw_polygon(cell.points, [overlayed_color])


func _on_Battle_game_state_changed(_battle: Battle):
	match _battle.get_state():
		BattleData.State.PLAYER_TURN:
			update_overlay(_battle.get_active_stack())
		_:
			update_overlay(null)
