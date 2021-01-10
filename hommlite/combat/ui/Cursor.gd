extends Node

var battle: Battle
var hexgrid: HexGrid

onready var _attack_tl = preload("res://assets/combat/cursor/cursor-sword-tl.png")
onready var _attack_tr = preload("res://assets/combat/cursor/cursor-sword-tr.png")
onready var _attack_br = preload("res://assets/combat/cursor/cursor-sword-br.png")
onready var _attack_bl = preload("res://assets/combat/cursor/cursor-sword-bl.png")
onready var _attack_r = preload("res://assets/combat/cursor/cursor-sword-r.png")
onready var _attack_l = preload("res://assets/combat/cursor/cursor-sword-l.png")

onready var _move = preload("res://assets/combat/cursor/cursor-move.png")
onready var _forbidden = preload("res://assets/combat/cursor/cursor-forbidden.png")


func setup(_battle: Battle, _hexgrid: HexGrid):
	battle = _battle
	hexgrid = _hexgrid


func _on_UI_mouse_moved(state: CursorState):
	if battle.get_state() == BattleData.State.IN_PROGRESS:
		match state.action:
			CursorState.Action.NONE:
				Input.set_custom_mouse_cursor(null)
			CursorState.Action.UNREACHABLE_CELL, CursorState.Action.UNREACHABLE_STACK:
				Input.set_custom_mouse_cursor(_forbidden, Input.CURSOR_ARROW, Vector2(16,16))
			CursorState.Action.REACHABLE_CELL:
				Input.set_custom_mouse_cursor(_move, Input.CURSOR_ARROW, Vector2(16,16))
			CursorState.Action.REACHABLE_STACK:
				var target_cell = hexgrid.get_cell_at_coords(state.target_stack.coordinates)
				_set_attack_cursor(target_cell, state.hover_hex_cell)
				
	else:
		Input.set_custom_mouse_cursor(null)


func _on_Battle_game_state_changed(battle: Battle):
	if battle.get_state() != BattleData.State.IN_PROGRESS:
		Input.set_custom_mouse_cursor(null)


func _set_attack_cursor(target: HexCell, nearest: HexCell):
	var items = _get_attack_cursor(target, nearest)
	Input.set_custom_mouse_cursor(items[0], Input.CURSOR_ARROW, items[1])


func _get_attack_cursor(target: HexCell, nearest: HexCell) -> Array:
	var direction = nearest.center - target.center
	
	if abs(direction.y) < 0.001:
		if direction.x > 0:
			return [_attack_l, Vector2(0, 9)]
		else:
			return [_attack_r, Vector2(40, 9)]
	else:
		if direction.y > 0:
			if direction.x > 0:
				return [_attack_tl, Vector2(0, 0)]
			else:
				return [_attack_tr, Vector2(31, 0)]
		else:
			if direction.x > 0:
				return [_attack_bl, Vector2(0, 31)]
			else:
				return [_attack_br, Vector2(31, 31)]
