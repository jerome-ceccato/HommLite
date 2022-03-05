class_name AllBattles
extends Reference


func get_battles_count(id: String):
	match id:
		"easy":
			return 2
		"medium":
			return 3
		"hard":
			return 4
	return 0


func get_reward(id: String):
	match id:
		"easy":
			return 100
		"medium":
			return 300
		"hard":
			return 800
	return 0


func get_battle_setup(id: String, index: int, player_army: Army):
	return BattleSetup.new([player_army, _make_army(id, index)], _get_map(id, index))


func _make_army(id: String, battle_index: int) -> Army:
	match id:
		"easy":
			match battle_index:
				0:
					return Army.new([
						Stack.new("chicken", 12),
					])
				1:
					return Army.new([
						Stack.new("chicken", 20),
						Stack.new("chicken", 25),
						Stack.new("chicken", 20),
					])
				_:
					return null
		"medium":
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
						Stack.new("bee", 2),
						Stack.new("cow", 3),
						Stack.new("bee", 2),
						Stack.new("cow", 3),
						Stack.new("bee", 2),
					])
				_:
					return null
		"hard":
			match battle_index:
				0:
					return Army.new([
						Stack.new("uchicken", 20),
						Stack.new("uchicken", 20),
						Stack.new("uchicken", 20),
					])
				1:
					return Army.new([
						Stack.new("cow", 5),
						Stack.new("uchicken", 6),
						Stack.new("uchicken", 7),
						Stack.new("uchicken", 6),
						Stack.new("cow", 5),
					])
				2:
					return Army.new([
						Stack.new("bee", 6),
						Stack.new("bee", 4),
						Stack.new("uchicken", 32),
						Stack.new("bee", 4),
						Stack.new("bee", 6),
					])
				3:
					return Army.new([
						Stack.new("cow", 42),
					])
				_:
					return null
	return null


func _get_map(id: String, battle_index: int) -> MapData:
	var bg = "res://assets/combat/bg.png"
	return MapData.new(bg, BattleCoords.new(13, 9), _make_obstacles(id, battle_index))


func _make_obstacles(id: String, battle_index: int) -> Array:
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
