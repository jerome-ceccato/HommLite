extends Node2D


func _on_Adventure_pressed():
	var scene_path = "res://src/scene/GameSceneManager.tscn"
	get_tree().change_scene(scene_path)
