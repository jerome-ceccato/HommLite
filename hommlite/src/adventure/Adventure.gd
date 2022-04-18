extends Node2D

onready var map: AdventureMap = $AdventureMap


func _ready():
	for child in [$Selector, $Debug, $Hero]:
		child.map = map
	$Hero.set_position_hex(Vector3.ZERO)
	
	$Selector.connect("adventure_tile_selected", self, "_on_hex_selected")


func _on_hex_selected(hex: Vector3):
	var hexdata: AdventureTile = map.hexmap.get_hex(hex)
	if hexdata and hexdata.revealed:
		if hexdata.get_entity_tile_id() == 1:
			_do_combat()
			_move_hero(hex)
			map.discard_entity(hex)
		elif hexdata.get_base_tile_id() == 0:
			_move_hero(hex)


func _move_hero(hex: Vector3):
	$Hero.set_position_hex(hex)
	for direction in range(6):
		map.reveal(map.hexmap.neighbor_hex(hex, direction))


func _do_combat():
	Context.current_world = CurrentWorld.new(WorldData.new("Test", "", "test", 1))
	Context.load_battle()
	
	var root = get_tree().get_root()
	
	var scene_path = "res://src/combat/CombatScene.tscn"
	var next_scene = load(scene_path).instance()
	root.add_child(next_scene)
	
	Context.adventure_scene = self
	root.remove_child(self)

