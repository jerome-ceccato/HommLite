extends Node2D


func _on_Adventure_pressed():
	var scene_path = "res://src/scene/GameSceneManager.tscn"
	get_tree().change_scene_to_file(scene_path)


func _on_Reset_pressed():
	Context.delete_save()
	Context.load_save()
	_on_Adventure_pressed()
