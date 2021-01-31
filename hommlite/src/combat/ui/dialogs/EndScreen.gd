extends Node2D

var _battle: Battle

onready var label: Label = $Label
onready var button: Button = $BackButton


func _ready():
	visible = false


func _on_Battle_game_state_changed(battle: Battle):
	if battle.get_state() == BattleData.State.COMBAT_ENDED:
		_battle = battle
		visible = true
		Input.set_custom_mouse_cursor(null)
		
		if battle.get_winner() == BattleStack.Side.LEFT:
			label.text = "Victory!"
			button.text = "Next battle"
		else:
			label.text = "Defeat!"
			button.text = "Back to title"


func _on_Titlescreen_pressed():
	if _battle.get_winner() == BattleStack.Side.LEFT:
		# TODO: this should be done outside of UI code when the battle ends
		Context.player_army = _battle.get_final_player_army()
		Context.battle_progress += 1
		Context.save()
		
		Context.load_battle()
		var combat_scene_path = "res://src/combat/CombatScene.tscn"
		get_tree().change_scene(combat_scene_path)
	else:
		Context.reset()
		var title_scene_path = "res://src/start/StartScreen.tscn"
		get_tree().change_scene(title_scene_path)

