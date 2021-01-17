extends Node2D

onready var label: Label = $Label

func _ready():
	visible = false


func _on_Battle_game_state_changed(battle: Battle):
	if battle.get_state() == BattleData.State.COMBAT_ENDED:
		visible = true
		Input.set_custom_mouse_cursor(null)
		
		if battle.get_winner() == BattleStack.Side.LEFT:
			label.text = "Victory!"
		else:
			label.text = "Defeat!"


func _on_Titlescreen_pressed():
	var title_scene_path = "res://start/StartScreen.tscn"
	get_tree().change_scene(title_scene_path)
