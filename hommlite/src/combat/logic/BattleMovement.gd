class_name BattleMovement
extends RefCounted

var path: Array # [BattleCoords]
var flying: bool


func _init(_path: Array,_flying: bool):
	path = _path
	flying = _flying
