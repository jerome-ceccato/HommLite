extends Node2D

func _on_Start_pressed():
	var combat_scene_path = "res://combat/CombatScene.tscn"
	get_tree().change_scene(combat_scene_path)
