extends Node

var _persistence := Persistence.new()

var player_army: Army

var all_battles: AllBattles
var selected_battle: String
var battle_progress: int
var current_battle : BattleSetup

var currency: int


func _ready():
	reset()


func reset():
	player_army = StartData.get_player_army()
	all_battles = AllBattles.new()
	battle_progress = 0
	selected_battle = ""
	currency = 0


func select_battle(id: String):
	selected_battle = id
	battle_progress = 0


func load_battle():
	if battle_progress < all_battles.get_battles_count(selected_battle):
		current_battle = all_battles.get_battle_setup(selected_battle, battle_progress, player_army)
		return true
	else:
		currency += all_battles.get_reward(selected_battle)
		battle_progress = 0
		selected_battle = ""
		return false


func has_save():
	return _persistence.has_save()

func load_save():
	_persistence.load_saved_context()

func save():
	_persistence.save_current_context()

func delete_save():
	_persistence.delete_save()
