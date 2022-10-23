extends Node2D
class_name AdventureScene

var _scene_navigation: GameSceneNavigation
func inject_scene_navigation(nav):
	_scene_navigation = nav


func _ready():
	pass


func _open_home_window():
	var scene = load("res://src/manage/Manage.tscn")
	var node = scene.instantiate()
	$Debug/CanvasLayer.add_child(node)


func prepare_for_combat_ended(victory: bool):
	Context.save()
	$Debug.refresh()


func _on_Combat_pressed():
	var army := Army.new({
		0: Stack.new("chicken", 18),
	})
	_scene_navigation.emit_signal("navigate_to_combat", army)
