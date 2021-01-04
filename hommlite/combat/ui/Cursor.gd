extends Node

var battle: Battle

onready var _attack = preload("res://assets/combat/cursor/cursor-sword.png")
onready var _move = preload("res://assets/combat/cursor/cursor-move.png")
onready var _forbidden = preload("res://assets/combat/cursor/cursor-forbidden.png")


func setup(_battle: Battle):
	battle = _battle


func _on_UI_mouse_moved(state: CursorState):
	match state.action:
		CursorState.Action.NONE:
			Input.set_custom_mouse_cursor(null)
		CursorState.Action.UNREACHABLE_CELL, CursorState.Action.UNREACHABLE_STACK:
			Input.set_custom_mouse_cursor(_forbidden)
		CursorState.Action.REACHABLE_CELL:
			Input.set_custom_mouse_cursor(_move)
		CursorState.Action.REACHABLE_STACK:
			Input.set_custom_mouse_cursor(_attack)
