extends Node2D


func _on_Start_pressed():
	if Context.current_world:
		_start_combat()
	else:
		_open_world_select()


func _open_world_select():
	var scene = load("res://src/world-select/WorldSelect.tscn")
	var node = scene.instance()
	
	add_child(node)


func _start_combat():
	Context.load_battle()
	var combat_scene_path = "res://src/combat/CombatScene.tscn"
	get_tree().change_scene(combat_scene_path)
