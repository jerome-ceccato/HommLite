extends Node2D

func _ready():
	$Continue.visible = Context.has_save()


func _on_Start_pressed():
	Context.load_battle()
	_start_combat()

func _on_Continue_pressed():
	Context.load_save()
	Context.load_battle()
	_start_combat()


func _start_combat():
	var combat_scene_path = "res://src/combat/CombatScene.tscn"
	get_tree().change_scene(combat_scene_path)
