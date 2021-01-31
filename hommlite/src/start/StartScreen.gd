extends Node2D



func _on_Start_pressed():
	Context.load_battle()
	var combat_scene_path = "res://src/combat/CombatScene.tscn"
	get_tree().change_scene(combat_scene_path)


func _on_Continue_pressed():
	pass # Replace with function body.
