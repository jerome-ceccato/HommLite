extends Node
class_name AdventureTile

const NO_TILE_ID = -1
const HIDDEN_TILE_ID = 3

var revealed
var _base_tile_id
var _details_tile_id
var _entity_tile_id

func _init(base_id: int, details_id: int, entity_id: int, revealed_: bool):
	_base_tile_id = base_id
	_details_tile_id = details_id
	_entity_tile_id = entity_id
	revealed = revealed_

func get_base_tile_id() -> int:
	return _base_tile_id if revealed else HIDDEN_TILE_ID

func get_details_tile_id() -> int:
	return _details_tile_id if revealed else NO_TILE_ID

func get_entity_tile_id() -> int:
	return _entity_tile_id if revealed else NO_TILE_ID

func delete_entity():
	_entity_tile_id = NO_TILE_ID
