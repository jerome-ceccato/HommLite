extends Node2D

func _ready():
	Context.load_save()


func _on_Start_pressed():
	var scene = load("res://src/world-select/WorldSelect.tscn")
	var node = scene.instance()
	
	add_child(node)
