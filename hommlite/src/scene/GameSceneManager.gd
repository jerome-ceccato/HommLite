extends Node2D

onready var container := $SceneContainer
onready var navigation := $Navigation

var _adventure_scene: AdventureScene

func _ready():
	_setup_navigation_bindings()
	_load_initial_scene()

func _load_initial_scene():
	var adventure_scene_path = "res://src/adventure/Adventure.tscn"
	var scene = load(adventure_scene_path).instance()
	_adventure_scene = scene
	_swap_scene(scene)

func _setup_navigation_bindings():
	navigation.connect("navigate_to_combat", self, "_on_navigate_to_combat")
	navigation.connect("navigate_to_adventure", self, "_on_navigate_to_adventure")


func _swap_scene(scene: Node2D):
	for n in container.get_children():
		container.remove_child(n)
		if n != _adventure_scene:
			n.queue_free()
	
	if scene.has_method("inject_scene_navigation"):
		scene.inject_scene_navigation(navigation)
	
	container.add_child(scene)

func _on_navigate_to_combat(world_data: WorldData):
	Context.current_world = CurrentWorld.new(world_data)
	Context.load_battle()
	
	var combat_scene_path = "res://src/combat/CombatScene.tscn"
	var next_scene = load(combat_scene_path).instance()
	_swap_scene(next_scene)


func _on_navigate_to_adventure(victory: bool):
	_adventure_scene.prepare_for_combat_ended(victory)
	_swap_scene(_adventure_scene)

