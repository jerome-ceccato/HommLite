extends Node2D

onready var battle := $Battle
onready var battle_queue := $BattleQueue
onready var ui := $UI

var left_army: Army
var right_army: Army

func _ready():
	var gob_sprite = load("res://assets/combat/gob.png")
	var skelly_sprite = load("res://assets/combat/skeleton.png")
	
	left_army = _create_army(UnitFactory.goblin(), 7)
	right_army = _create_army(UnitFactory.skeleton(), 5)
	
	battle.setup_battle(left_army, right_army)
	battle_queue.setup(battle)
	ui.setup(battle, battle_queue)
	
	battle_queue.run()

func _create_army(unit: Unit, n_units: int) -> Army:
	var array = []
	for i in n_units:
		array.append(UnitStack.new(unit, 1))
	return Army.new(array)
