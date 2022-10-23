extends Node2D

@onready var container := $SceneContainer
@onready var navigation := $Node3D
@onready var _transition_player := $Canvas/SceneTransition/AnimationPlayer

var _adventure_scene: AdventureScene

func _ready():
	_setup_navigation_bindings()
	_load_initial_scene()

func _load_initial_scene():
	var adventure_scene_path = "res://src/adventure/Adventure.tscn"
	var scene = load(adventure_scene_path).instantiate()
	_adventure_scene = scene
	_swap_scene(scene)

func _setup_navigation_bindings():
	navigation.connect("navigate_to_combat",Callable(self,"_on_navigate_to_combat"))
	navigation.connect("navigate_to_adventure",Callable(self,"_on_navigate_to_adventure"))


func _swap_scene(scene: Node2D):
	if container.get_child_count() != 0:
		_transition_player.play("Fade")
		await _transition_player.animation_finished
		
		for n in container.get_children():
			container.remove_child(n)
			if n != _adventure_scene:
				n.queue_free()
	
	if scene.has_method("inject_scene_navigation"):
		scene.inject_scene_navigation(navigation)
	
	container.add_child(scene)
	_transition_player.play_backwards("Fade")

func _on_navigate_to_combat(army: Army):
	Context.load_battle(army)
	
	var combat_scene_path = "res://src/combat/CombatScene.tscn"
	var next_scene = load(combat_scene_path).instantiate()
	_swap_scene(next_scene)


func _on_navigate_to_adventure(victory: bool):
	_adventure_scene.prepare_for_combat_ended(victory)
	_swap_scene(_adventure_scene)

