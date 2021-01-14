class_name BattleSetup
extends Reference

var left_army: ArmyData
var right_army: ArmyData

var obstacles: Array # [ObstacleData]

func _init(armies: Array, _obstacles: Array):
	left_army = armies[0]
	right_army = armies[1]
	obstacles = _obstacles
