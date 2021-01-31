extends Node2D

onready var wait_button: AnyActionButton = $WaitButton
onready var def_button: AnyActionButton = $DefButton

var events: UIEvents


func setup(_events: UIEvents):
	events = _events


func _on_Wait_pressed():
	events.emit_signal("action_wait")

func _on_Def_pressed():
	events.emit_signal("action_skip")


func _set_active(button: AnyActionButton, active: bool):
	button.set_active(active)


func _on_Battle_game_state_changed(battle: Battle):
	match battle.get_state():
		BattleData.State.PLAYER_TURN:
			_set_active(wait_button, battle.active_stack_can_wait())
			_set_active(def_button, true)
		_:
			_set_active(wait_button, false)
			_set_active(def_button, false)
