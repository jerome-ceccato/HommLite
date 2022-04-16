extends Node
class_name AdventureTile

const HIDDEN_TILE_ID = 3

var revealed
var _tile_id

func _init(id: int, revealed_: int):
	_tile_id = id
	revealed = revealed_

func get_tile_id() -> int:
	return _tile_id if revealed else HIDDEN_TILE_ID
