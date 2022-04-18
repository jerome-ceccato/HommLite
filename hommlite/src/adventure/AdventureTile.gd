extends Node
class_name AdventureTile

const NO_TILE = -1
enum BaseTileID {
	HIDDEN_TILE = 3,
	GRASS = 4,
	GRASS2 = 5,
	WATER = 6,
	WATER2 = 7,
	MOUNTAIN = 8,
	MOUNTAIN2 = 9,
}

enum DetailTileID {
	FLOWER = 0,
}

enum EntityTileID {
	HOME = 0,
	ENEMY = 1,
}

enum OutlineTileID {
	BASE = 0,
}

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
	return _base_tile_id if revealed else BaseTileID.HIDDEN_TILE

func get_details_tile_id() -> int:
	return _details_tile_id if revealed else NO_TILE

func get_entity_tile_id() -> int:
	return _entity_tile_id if revealed else NO_TILE

func get_outline_tile_id() -> int:
	return OutlineTileID.BASE if revealed else NO_TILE

func delete_entity():
	_entity_tile_id = NO_TILE


func serialized() -> Dictionary:
	return {
		"revealed": revealed,
		"_base_tile_id": _base_tile_id,
		"_details_tile_id": _details_tile_id,
		"_entity_tile_id": _entity_tile_id,
	}

func deserialize(data: Dictionary) -> AdventureTile:
	revealed = data["revealed"]
	_base_tile_id = data["_base_tile_id"]
	_details_tile_id = data["_details_tile_id"]
	_entity_tile_id = data["_entity_tile_id"]
	return self
