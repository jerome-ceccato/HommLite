extends Node

var _persistence := Persistence.new()

var player_army: Army

var all_battles: AllBattles
var battle_progress: int
var current_battle : BattleSetup


func _ready():
	reset()


func reset():
	player_army = StartData.get_player_army()
	all_battles = AllBattles.new()
	battle_progress = 0


func load_battle():
	var progress = battle_progress % all_battles.n_battles
	current_battle = all_battles.get_battle_setup(progress, player_army)


func has_save():
	return _persistence.has_save()

func load_save():
	_persistence.load_saved_context()

func save():
	_persistence.save_current_context()

func delete_save():
	_persistence.delete_save()
