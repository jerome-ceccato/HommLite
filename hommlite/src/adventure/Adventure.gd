extends Node2D

onready var map: AdventureMap = $AdventureMap


func _ready():
	for child in [$Selector, $Debug, $Hero]:
		child.map = map
		
#	if Context.adventure_map:
#		$Hero.set_position_hex(Context.adventure_map.player_pos)
#	else:
#		$Hero.set_position_hex(Vector3.ZERO)
	$Hero.set_position_hex(Vector3.ZERO)
	
	$Selector.connect("adventure_tile_selected", self, "_on_hex_selected")


func _on_hex_selected(hex: Vector3):
	var hexdata: AdventureTile = map.hexmap.get_hex(hex)
	if hexdata and hexdata.revealed:
		if hexdata.get_entity_tile_id() == AdventureTile.EntityTileID.ENEMY:
			_do_combat()
			_move_hero(hex)
			map.discard_entity(hex)
			_save()
		elif hexdata.get_base_tile_id() == AdventureTile.BaseTileID.GRASS or hexdata.get_base_tile_id() == AdventureTile.BaseTileID.GRASS2:
			_move_hero(hex)
			_save()


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

func recover_after_combat():
	# use signals
	$Debug.refresh()

func _save():
	var save_data = AdventureSaveData.new()
	save_data.hexmap = map.hexmap.get_all_hex()
	save_data.player_pos = $Hero.get_position_hex()
	Context.adventure_map = save_data
	Context.save()
	

