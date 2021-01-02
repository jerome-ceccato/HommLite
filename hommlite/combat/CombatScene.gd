extends Node2D

onready var battle := $Battle
onready var ui := $UI

var left_army: ArmyData
var right_army: ArmyData

func _ready():
	left_army = _create_army([
		UnitFactory.goblin(),
		UnitFactory.skeleton(),
		UnitFactory.skeleton(),
		UnitFactory.skeleton(),
		UnitFactory.goblin()
	])
	right_army = _create_army([
		UnitFactory.skeleton(),
		UnitFactory.goblin(),
		UnitFactory.skeleton()
	])
	
	battle.setup_battle(left_army, right_army)
	ui.setup(battle)
	
	battle.queue.run()

func _create_army(units: Array) -> ArmyData:
	var array = []
	for unit in units:
		array.append(StackData.new(unit, 1))
	return ArmyData.new(array)
