extends Node

var battle: Battle
var hexgrid: CombatHexGrid

@onready var _attack_tl = preload("res://assets/combat/cursor/cursor-sword-tl.png")
@onready var _attack_tr = preload("res://assets/combat/cursor/cursor-sword-tr.png")
@onready var _attack_br = preload("res://assets/combat/cursor/cursor-sword-br.png")
@onready var _attack_bl = preload("res://assets/combat/cursor/cursor-sword-bl.png")
@onready var _attack_r = preload("res://assets/combat/cursor/cursor-sword-r.png")
@onready var _attack_l = preload("res://assets/combat/cursor/cursor-sword-l.png")
@onready var _range_attack = preload("res://assets/combat/cursor/cursor-ranged-attack.png")
@onready var _move = preload("res://assets/combat/cursor/cursor-move.png")
@onready var _forbidden = preload("res://assets/combat/cursor/cursor-forbidden.png")


func setup(_battle: Battle, _hexgrid: CombatHexGrid):
	battle = _battle
	hexgrid = _hexgrid


func _on_UI_mouse_moved(state: CursorState):
	if battle.get_state() == BattleData.State.PLAYER_TURN:
		match state.action:
			CursorState.Action.NONE:
				Input.set_custom_mouse_cursor(null)
			CursorState.Action.UNREACHABLE_CELL, CursorState.Action.UNREACHABLE_STACK:
				Input.set_custom_mouse_cursor(_forbidden, Input.CURSOR_ARROW, Vector2(16,16))
			CursorState.Action.REACHABLE_CELL:
				Input.set_custom_mouse_cursor(_move, Input.CURSOR_ARROW, Vector2(16,16))
			CursorState.Action.REACHABLE_STACK:
				var target_cell = hexgrid.get_cell_at_coords(state.target_stack.coordinates)
				_set_attack_cursor(target_cell, state.hover_hex_cells)
			CursorState.Action.RANGED_REACHABLE_STACK:
				Input.set_custom_mouse_cursor(_range_attack, Input.CURSOR_ARROW, Vector2(16,16))
	else:
		Input.set_custom_mouse_cursor(null)


func _on_Battle_game_state_changed(_unused: Battle):
	if battle.get_state() != BattleData.State.PLAYER_TURN:
		Input.set_custom_mouse_cursor(null)


func _set_attack_cursor(target: CombatHexCell, cells: Array):
	var items = _get_attack_cursor(target.center, _nearest(target, cells).center)
	Input.set_custom_mouse_cursor(items[0], Input.CURSOR_ARROW, items[1])


func _nearest(target: CombatHexCell, cells: Array) -> CombatHexCell:
	if cells.is_empty():
		return target
	
	var nearest = null
	for cell in cells:
		if nearest == null:
			nearest = cell
		else:
			if target.center.distance_to(nearest.center) > target.center.distance_to(cell.center):
				nearest = cell
	return nearest


func _get_attack_cursor(target: Vector2, nearest: Vector2) -> Array:
	var direction = nearest - target
	
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
