class_name BattleSetup
extends RefCounted

var left_army: Army
var right_army: Army

var map: MapData

func _init(armies: Array,_map: MapData):
	left_army = armies[0]
	right_army = armies[1]
	map = _map
