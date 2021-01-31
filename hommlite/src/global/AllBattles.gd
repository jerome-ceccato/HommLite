class_name AllBattles
extends Reference

var n_battles := 3


func get_battle_setup(index: int, player_army: Army):
	return BattleSetup.new([player_army, _make_army(index)], _get_map(index))


func _make_army(battle_index: int) -> Army:
	match battle_index:
		0:
			return Army.new([
				Stack.new("chicken", 36),
			])
		1:
			return Army.new([
				Stack.new("chicken", 27),
				Stack.new("uchicken", 6),
				Stack.new("chicken", 27),
			])
		2:
			return Army.new([
				Stack.new("bee", 6),
				Stack.new("cow", 3),
				Stack.new("bee", 6),
				Stack.new("cow", 3),
				Stack.new("bee", 6),
			])
		_:
			return null


func _get_map(battle_index: int) -> MapData:
	var bg = "res://assets/combat/bg.png"
	return MapData.new(bg, BattleCoords.new(13, 9), _make_obstacles(battle_index))


func _make_obstacles(battle_index: int) -> Array:
	var rock_reference = "res://assets/combat/rock.png"
	return [
		ObstacleData.new(BattleCoords.new(3, 5), rock_reference),
		ObstacleData.new(BattleCoords.new(4, 4), rock_reference),
		ObstacleData.new(BattleCoords.new(5, 4), rock_reference),
		ObstacleData.new(BattleCoords.new(5, 3), rock_reference),
		ObstacleData.new(BattleCoords.new(6, 3), rock_reference),
		ObstacleData.new(BattleCoords.new(7, 3), rock_reference),
		ObstacleData.new(BattleCoords.new(8, 4), rock_reference),
		ObstacleData.new(BattleCoords.new(8, 5), rock_reference),
	]
