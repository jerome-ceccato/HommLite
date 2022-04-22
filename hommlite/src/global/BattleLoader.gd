extends Reference
class_name BattleLoader

func load_battle(player_army: Army, enemy_army: Army) -> BattleSetup:
	return BattleSetup.new([player_army, enemy_army], _get_map())


func _get_map() -> MapData:
	var bg = "res://assets/combat/bg.png"
	return MapData.new(bg, BattleCoords.new(13, 9), _make_obstacles())

func _make_obstacles() -> Array:
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
