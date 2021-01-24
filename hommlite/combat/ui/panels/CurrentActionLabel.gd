extends RichTextLabel

var battle: Battle
var observed_buttons: Array # [AnyActionButton]
var _log_helper: LogHelper
var _last_state: CursorState


func setup(_battle: Battle, log_helper: LogHelper):
	battle = _battle
	_log_helper = log_helper


func _ready():
	clear()


func _set_content(content: String):
	parse_bbcode("[center]" + content + "[/center]")


func _stack_name(stack: BattleStack):
	return _log_helper.side_color(_log_helper.pluralized_name(stack.stack.unit, stack.amount), stack.side)


func _unreachable_stack(target: BattleStack):
	var unit_name = _stack_name(target)
	_set_content("%s %s" % [target.amount, unit_name])

func _reachable_stack(target: BattleStack, active: BattleStack, ranged: bool):
	var unit_name = _stack_name(target)
	var action = "Shoot" if ranged else "Attack"
	var dmg_range = active.damage_range(target, ranged)
	var low_killed = target.amount_killed(dmg_range[0])
	var high_killed = target.amount_killed(dmg_range[1])
	
	var dmg_string = null
	if dmg_range[0] == dmg_range[1]:
		dmg_string = "%s" % [dmg_range[0]]
	else:
		dmg_string = "%s-%s" % [dmg_range[0], dmg_range[1]]
	
	var kills_string = null
	if low_killed == high_killed:
		if low_killed == 0:
			kills_string = ""
		else:
			kills_string = ", kills: %s" % [low_killed]
	else:
		kills_string = ", kills: %s-%s" % [low_killed, high_killed]
	
	_set_content("%s %s (dmg: %s%s)" % [action, unit_name, dmg_string, kills_string])

func _reachable_cell(active: BattleStack):
	var unit_name = _stack_name(active)
	_set_content("Move %s here" % [unit_name])


func _read_cursor_state(state: CursorState):
	if state == null:
		return
	
	if battle.get_state() == BattleData.State.PLAYER_TURN:
		match state.action:
			CursorState.Action.NONE:
				_find_mouse_over()
			CursorState.Action.UNREACHABLE_CELL:
				clear()
			CursorState.Action.UNREACHABLE_STACK:
				_unreachable_stack(state.target_stack)
			CursorState.Action.REACHABLE_CELL:
				_reachable_cell(state.active_stack)
			CursorState.Action.REACHABLE_STACK:
				_reachable_stack(state.target_stack, state.active_stack, false)
			CursorState.Action.RANGED_REACHABLE_STACK:
				_reachable_stack(state.target_stack, state.active_stack, true)


func _find_mouse_over():
	if observed_buttons:
		for container in observed_buttons:
			if container is AnyActionButton:
				var button := container as AnyActionButton
				if button.button.is_hovered():
					_set_content(button.display_name)
					return
	clear()


func _on_UI_mouse_moved(state: CursorState):
	_last_state = state
	_read_cursor_state(state)


func _on_Battle_game_state_changed(_unused: Battle):
	match battle.get_state():
		BattleData.State.PLAYER_TURN:
			_read_cursor_state(_last_state)
		BattleData.State.AI_TURN, BattleData.State.WAITING_FOR_UI:
			clear()
		BattleData.State.COMBAT_ENDED:
			_set_content("The combat has ended")
