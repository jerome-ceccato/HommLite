extends Node2D

func _on_Start_pressed():
	_setup_combat()
	var combat_scene_path = "res://combat/CombatScene.tscn"
	get_tree().change_scene(combat_scene_path)


func _setup_combat():
	var bg = "res://assets/combat/bg.png"
	var map = MapData.new(bg, BattleCoords.new(13, 9), _make_obstacles())
	Context.current_battle = BattleSetup.new(_make_armies(), map)


func _make_armies() -> Array:
	var bee = load("res://assets/data/bee.tres")
	var chicken = load("res://assets/data/chicken.tres")
	var uchicken = load("res://assets/data/uchicken.tres")
	var bbee = load("res://assets/data/bigbee.tres")
	var template = load("res://assets/data/template.tres")
	
	var left_army = ArmyData.new([
		StackData.new(bee, 14),
		StackData.new(uchicken, 9),
	])
	
	var right_army = ArmyData.new([
		StackData.new(chicken, 27),
		StackData.new(chicken, 28),
		StackData.new(chicken, 27),
	])
	
	return [left_army, right_army]


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
