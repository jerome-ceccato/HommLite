extends Node2D

onready var _end_screen: Control = $EndScreen
onready var _end_screen_label: Label = $EndScreen/Label

func _ready():
	_end_screen.visible = false


func _on_Battle_game_state_changed(battle: Battle):
	if battle.get_state() == BattleData.State.COMBAT_ENDED:
		_end_screen.visible = true
		Input.set_custom_mouse_cursor(null)
		
		if battle._manager.get_winner() == BattleStack.Side.LEFT:
			_end_screen_label.text = "Victory!"
		else:
			_end_screen_label.text = "Defeat!"
