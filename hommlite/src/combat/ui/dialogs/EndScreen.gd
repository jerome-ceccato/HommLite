extends Node2D

var _battle: Battle
var scene_navigation: GameSceneNavigation

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
		else:
			label.text = "Defeat!"
		button.text = "Back to adventure"


func _on_Titlescreen_pressed():
	var result = _battle.get_winner() == BattleStack.Side.LEFT
	scene_navigation.emit_signal("navigate_to_adventure", result)

