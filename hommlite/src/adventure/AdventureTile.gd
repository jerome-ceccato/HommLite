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

enum OutlineTileID {
	BASE = 0,
}

var revealed: bool
var _base_tile_id: int
var _details_tile_id: int
var _entity: AdventureTileEntity

func _init(base_id: int, details_id: int, entity: AdventureTileEntity, revealed_: bool):
	_base_tile_id = base_id
	_details_tile_id = details_id
	_entity = entity
	revealed = revealed_

func get_base_tile_id() -> int:
	return _base_tile_id if revealed else BaseTileID.HIDDEN_TILE

func get_details_tile_id() -> int:
	return _details_tile_id if revealed else NO_TILE

func get_entity_tile_id() -> int:
	return _entity.get_tile_id() if _entity and revealed else NO_TILE

func get_entity() -> AdventureTileEntity:
	return _entity

func get_outline_tile_id() -> int:
	return OutlineTileID.BASE if get_base_tile_id() != BaseTileID.HIDDEN_TILE else NO_TILE

func delete_entity():
	_entity = null


func serialized() -> Dictionary:
	var data = {
		"revealed": revealed,
		"_base_tile_id": _base_tile_id,
		"_details_tile_id": _details_tile_id,
	}
	if _entity:
		data["_entity"] = _entity.serialized()
	return data

func deserialize(data: Dictionary) -> AdventureTile:
	revealed = data["revealed"]
	_base_tile_id = data["_base_tile_id"]
	_details_tile_id = data["_details_tile_id"]
	if data.has("_entity"):
		_entity = AdventureTileEntity.new().deserialize(data["_entity"])
	else:
		_entity = null
	return self
