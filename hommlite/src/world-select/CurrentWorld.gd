class_name CurrentWorld
extends Reference

var world_data: WorldData
var battle_progress: int = 0

var all_battles: AllBattles = AllBattles.new()
var current_battle: BattleSetup = null


func _init(_world_data: WorldData):
	world_data = _world_data
	if world_data:
		all_battles.setup_for(world_data.difficulty)


func has_next_battle() -> bool:
	return (battle_progress + 1) < all_battles.get_battles_count()


func load_battle(player_army: Army):
	var progress = battle_progress % all_battles.get_battles_count()
	current_battle = all_battles.get_battle_setup(progress, player_army)


func serialized() -> Dictionary:
	return {
		"world_data": world_data.serialized(),
		"battle_progress": battle_progress,
	}

func deserialize(data: Dictionary) -> CurrentWorld:
	world_data = WorldData.new("", "", "", 0).deserialize(data["world_data"])
	battle_progress = data["battle_progress"]
	all_battles = AllBattles.new()
	all_battles.setup_for(world_data.difficulty)
	return self
