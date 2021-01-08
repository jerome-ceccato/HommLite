extends Node2D

onready var _end_screen: Control = $EndScreen
onready var _end_screen_label: Label = $EndScreen/Label

func _ready():
	_end_screen.visible = false


func _on_Battle_game_ended(winner_side: bool):
	_end_screen.visible = true
	if winner_side == BattleStack.Side.LEFT:
		_end_screen_label.text = "Victory!"
	else:
		_end_screen_label.text = "Defeat!"
