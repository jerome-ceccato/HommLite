extends Node2D

func _ready():
	Context.load_save()


func _on_Start_pressed():
	if Context.selected_battle != "" && Context.load_battle():
		_start_combat()
	else:
		var scene = load("res://src/world-select/WorldSelect.tscn")
		var node = scene.instance()
		
		add_child(node)


func _start_combat():
	var combat_scene_path = "res://src/combat/CombatScene.tscn"
	get_tree().change_scene(combat_scene_path)
