extends Node
class_name AdventureTileEnemy

enum TileID {
	ENEMY = 1,
	ENEMY2 = 2,
}

var _tile_id: int
var _army: Army


func _init(id: int, army: Army):
	_tile_id = id
	_army = army


func get_tile_id() -> int:
	return _tile_id

func get_army() -> Army:
	return _army


func serialized() -> Dictionary:
	return {
		"tile_id": _tile_id,
		"army": _army.serialized(),
	}

func deserialize(data: Dictionary) -> AdventureTileEnemy:
	_tile_id = int(data["tile_id"])
	_army = Army.new({}).deserialize(data["army"])
	return self
