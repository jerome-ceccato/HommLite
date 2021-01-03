extends Node

var battle: Battle

onready var _attack = preload("res://assets/combat/cursor/cursor-sword.png")
onready var _move = preload("res://assets/combat/cursor/cursor-move.png")
onready var _forbidden = preload("res://assets/combat/cursor/cursor-forbidden.png")


func setup(_battle: Battle):
	battle = _battle


func _on_UI_hex_grid_hovered(coords: BattleCoords):
	if coords != null:
		var active_stack = battle.queue.get_active_stack()
		var targetted_stack = battle.state.get_stack_at(coords)
		
		if targetted_stack != null:
			if targetted_stack.side != active_stack.side:
				if battle.state.can_attack(active_stack, targetted_stack):
					Input.set_custom_mouse_cursor(_attack)
				else:
					Input.set_custom_mouse_cursor(_forbidden)
			else:
				Input.set_custom_mouse_cursor(_forbidden)
		else:
			if battle.state.can_reach(active_stack, coords):
				Input.set_custom_mouse_cursor(_move)
			else:
				Input.set_custom_mouse_cursor(_forbidden)
	else:
		Input.set_custom_mouse_cursor(null)
