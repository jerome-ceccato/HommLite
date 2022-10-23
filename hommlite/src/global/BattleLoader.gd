extends RefCounted
class_name BattleLoader

static func load_battle(player_army: Army, enemy_army: Army) -> BattleSetup:
	return BattleSetup.new([player_army, enemy_army], _get_map())


static func _get_map() -> MapData:
	var panel = "res://assets/combat/bg.png"
	return MapData.new(panel, BattleCoords.new(13, 9), _make_obstacles())

static func _make_obstacles() -> Array:
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
