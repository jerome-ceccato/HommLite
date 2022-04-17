extends Node2D

var _battle: Battle
var _world_data: WorldData

onready var label: Label = $Label
onready var button: Button = $BackButton


func _ready():
	visible = false


func _on_Battle_game_state_changed(battle: Battle):
	if battle.get_state() == BattleData.State.COMBAT_ENDED:
		_battle = battle
		_world_data = Context.current_world.world_data
		
		visible = true
		Input.set_custom_mouse_cursor(null)
		
		if battle.get_winner() == BattleStack.Side.LEFT:
			label.text = "Victory!"
			if Context.current_world.has_next_battle():
				button.text = "Next battle"
			else:
				button.text = "Back to title"
		else:
			label.text = "Defeat!"
			button.text = "Back to title"


func _on_Titlescreen_pressed():
	if Context.current_world:
		Context.load_battle()
		var combat_scene_path = "res://src/combat/CombatScene.tscn"
		get_tree().change_scene(combat_scene_path)
	else:
		#var title_scene_path = "res://src/start/StartScreen.tscn"
		get_tree().get_root().add_child(Context.adventure_scene)
		var scene = get_parent().get_parent().get_parent()
		get_tree().get_root().remove_child(scene)
		scene.queue_free()
		#get_tree().change_scene(title_scene_path)
