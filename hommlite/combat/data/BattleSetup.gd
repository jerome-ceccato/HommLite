class_name BattleSetup
extends Reference

var left_army: ArmyData
var right_army: ArmyData

var map: MapData

func _init(armies: Array, _map: MapData):
	left_army = armies[0]
	right_army = armies[1]
	map = _map
