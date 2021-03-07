extends Node

var _persistence := Persistence.new()

var player_army: Army
var current_world: CurrentWorld


func _ready():
	player_army = StartData.get_player_army()
	current_world = null
	load_save()


func load_battle():
	if current_world:
		current_world.load_battle(player_army)


func advance_to_next_battle():
	if current_world:
		if current_world.has_next_battle():
			current_world.battle_progress += 1
		else:
			current_world = null


func did_lose_battle():
	delete_save()
	player_army = StartData.get_player_army()
	current_world = null


func has_save():
	return _persistence.has_save()

func load_save():
	_persistence.load_saved_context()

func save():
	_persistence.save_current_context()

func delete_save():
	_persistence.delete_save()
