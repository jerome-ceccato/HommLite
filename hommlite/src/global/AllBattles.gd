class_name AllBattles
extends Reference

var _battles: Array # [Army]

func setup_for(id: String):
	match id:
		"test":
			_battles = [
				Army.new([
					Stack.new("chicken", 1),
				]),
			]
		"easy":
			_battles = [
				Army.new([
					Stack.new("chicken", 12),
				]),
				Army.new([
					Stack.new("chicken", 20),
					Stack.new("chicken", 25),
					Stack.new("chicken", 20),
				]),
			]
		"medium":
			_battles = [
				Army.new([
					Stack.new("chicken", 36),
				]),
				Army.new([
					Stack.new("chicken", 27),
					Stack.new("uchicken", 6),
					Stack.new("chicken", 27),
				]),
				Army.new([
					Stack.new("bee", 2),
					Stack.new("cow", 3),
					Stack.new("bee", 2),
					Stack.new("cow", 3),
					Stack.new("bee", 2),
				]),
			]
		"hard":
			_battles = [
				Army.new([
					Stack.new("uchicken", 20),
					Stack.new("uchicken", 20),
					Stack.new("uchicken", 20),
				]),
				Army.new([
					Stack.new("cow", 5),
					Stack.new("uchicken", 6),
					Stack.new("uchicken", 7),
					Stack.new("uchicken", 6),
					Stack.new("cow", 5),
				]),
				Army.new([
					Stack.new("bee", 6),
					Stack.new("bee", 4),
					Stack.new("uchicken", 32),
					Stack.new("bee", 4),
					Stack.new("bee", 6),
				]),
				Army.new([
					Stack.new("cow", 42),
				])
			]


func get_battles_count():
	return _battles.size()


func get_battle_setup(index: int, player_army: Army):
	return BattleSetup.new([player_army, _battles[index]], _get_map(index))


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
