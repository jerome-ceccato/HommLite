class_name MapData
extends Reference

var bg_texture_path: String
var map_size: BattleCoords
var obstacles: Array # [ObstacleData]


func _init(_bg_texture_path: String, _map_size: BattleCoords, _obstacles: Array):
	bg_texture_path = _bg_texture_path
	map_size = _map_size
	obstacles = _obstacles
