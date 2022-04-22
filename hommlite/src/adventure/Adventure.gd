extends Node2D
class_name AdventureScene

onready var map: AdventureMap = $AdventureMap

var _scene_navigation: GameSceneNavigation setget inject_scene_navigation
func inject_scene_navigation(nav):
	_scene_navigation = nav

var _combat_target_hex: Vector3

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
	if hexdata and hexdata.visibility != AdventureTileVisibility.HIDDEN:
		var entity = hexdata.get_entity()
		if entity and entity.get_type() == AdventureTileEntity.Type.BUILDING:
			_move_hero(hex)
			_save()
			_open_home_window()
		elif entity and entity.get_type() == AdventureTileEntity.Type.ENEMY:
			_combat_target_hex = hex
			_do_combat(entity.get_data())
		elif hexdata.can_traverse():
			_move_hero(hex)
			_save()


func _open_home_window():
	var scene = load("res://src/manage/Manage.tscn")
	var node = scene.instance()
	$Debug/CanvasLayer.add_child(node)


func _move_hero(hex: Vector3):
	$Hero.set_position_hex(hex)
	map.reveal(hex, true)


func _do_combat(entity: AdventureTileEnemy):
	_scene_navigation.emit_signal("navigate_to_combat", entity.get_army())


func prepare_for_combat_ended(victory: bool):
	if victory:
		_move_hero(_combat_target_hex)
		map.discard_entity(_combat_target_hex)
	else:
		_move_hero(Vector3.ZERO)
	_save()
	$Debug.refresh()


func _save():
	var save_data = AdventureSaveData.new()
	save_data.hexmap = map.hexmap.get_all_hex()
	save_data.player_pos = $Hero.get_position_hex()
	Context.adventure_map = save_data
	Context.save()
	

