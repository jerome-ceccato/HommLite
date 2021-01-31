extends Node

var player_army: ArmyData

var all_battles: AllBattles
var battle_progress: int
var current_battle : BattleSetup


func _ready():
	reset()


func reset():
	player_army = PlayerArmy.get_army()
	all_battles = AllBattles.new()
	battle_progress = 0


func load_battle():
	var progress = battle_progress % all_battles.n_battles
	current_battle = all_battles.get_battle_setup(progress, player_army)
