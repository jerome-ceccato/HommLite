extends Node

var _persistence := Persistence.new()
var _battle_loader := BattleLoader.new()

var player_army: Army
var current_battle: BattleSetup
var souls: int

var adventure_map: AdventureSaveData
var adventure_scene

func _ready():
	_init_globals()
	load_save()

func _init_globals():
	player_army = StartData.get_player_army()
	current_battle = null
	adventure_map = null
	souls = 0

func load_battle(target: Army):
	current_battle = _battle_loader.load_battle(player_army, target)

func finish_battle(victory: bool):
	if victory:
		souls += 1
	else:
		delete_save()
		_init_globals()


func has_save():
	return _persistence.has_save()

func load_save():
	_persistence.load_saved_context()

func save():
	_persistence.save_current_context()

func delete_save():
	_persistence.delete_save()
