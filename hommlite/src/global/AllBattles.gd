class_name AllBattles
extends Reference

var n_battles := 3

var _bee = preload("res://assets/data/bee.tres")
var _chicken = preload("res://assets/data/chicken.tres")
var _uchicken = preload("res://assets/data/uchicken.tres")
var _cow = preload("res://assets/data/cow.tres")


func get_battle_setup(index: int, player_army: ArmyData):
	return BattleSetup.new([player_army, _make_army(index)], _get_map(index))


func _make_army(battle_index: int) -> ArmyData:
	match battle_index:
		0:
			return ArmyData.new([
				StackData.new(_chicken, 36),
			])
		1:
			return ArmyData.new([
				StackData.new(_chicken, 27),
				StackData.new(_uchicken, 6),
				StackData.new(_chicken, 27),
			])
		2:
			return ArmyData.new([
				StackData.new(_bee, 6),
				StackData.new(_cow, 3),
				StackData.new(_bee, 6),
				StackData.new(_cow, 3),
				StackData.new(_bee, 6),
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
