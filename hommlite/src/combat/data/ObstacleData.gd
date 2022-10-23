class_name ObstacleData
extends RefCounted

var coordinates: BattleCoords
var texture_reference: String

func _init(coord: BattleCoords,texture: String):
	coordinates = coord
	texture_reference = texture
