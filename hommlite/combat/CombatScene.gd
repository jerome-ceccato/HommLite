extends Node2D

onready var battle := $Battle
onready var ui := $UI

var left_army: ArmyData
var right_army: ArmyData

func _ready():
	var gob_sprite = load("res://assets/combat/gob.png")
	var skelly_sprite = load("res://assets/combat/skeleton.png")
	
	left_army = _create_army(UnitFactory.goblin(), 7)
	right_army = _create_army(UnitFactory.skeleton(), 5)
	
	battle.setup_battle(left_army, right_army)
	ui.setup(battle)
	
	battle.queue.run()

func _create_army(unit: UnitData, n_units: int) -> ArmyData:
	var array = []
	for i in n_units:
		array.append(StackData.new(unit, 1))
	return ArmyData.new(array)
