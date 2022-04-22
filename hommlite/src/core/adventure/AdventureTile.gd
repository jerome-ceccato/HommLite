extends Node
class_name AdventureTile

const NO_TILE = -1

enum BaseTileID {
	GRASS = 4,
	GRASS2 = 5,
	WATER = 6,
	WATER2 = 7,
	MOUNTAIN = 8,
	MOUNTAIN2 = 9,
}

enum DetailTileID {
	FLOWER = 0,
	FOG = 16,
}

enum OutlineTileID {
	BASE = 0,
}

var visibility: int
var _base_tile_id: int
var _details_tile_id: int
var _entity: AdventureTileEntity

func _init(base_id: int, details_id: int, entity: AdventureTileEntity, visibility_: int):
	_base_tile_id = base_id
	_details_tile_id = details_id
	_entity = entity
	visibility = visibility_


func _base_layer_visible() -> bool:
	return visibility != AdventureTileVisibility.HIDDEN

func _extra_layers_visible() -> bool:
	return visibility == AdventureTileVisibility.VISIBLE


func get_base_tile_id() -> int:
	if _base_layer_visible():
		return _base_tile_id
	return NO_TILE

func get_details_tile_id() -> int:
	if _extra_layers_visible():
		return _details_tile_id
	elif _base_layer_visible():
		return DetailTileID.FOG
	return NO_TILE

func get_entity_tile_id() -> int:
	if _entity and _extra_layers_visible():
		return _entity.get_tile_id()
	return NO_TILE

func get_outline_tile_id() -> int:
	if _base_layer_visible():
		return OutlineTileID.BASE
	return NO_TILE


func get_entity() -> AdventureTileEntity:
	return _entity

func delete_entity():
	_entity = null


func can_traverse() -> bool:
	var id = get_base_tile_id()
	return id in [BaseTileID.GRASS, BaseTileID.GRASS2]


func serialized() -> Dictionary:
	var data = {
		"visibility": visibility,
		"base_id": _base_tile_id,
	}
	if _details_tile_id != NO_TILE:
		data["details_id"] = _details_tile_id
	if _entity:
		data["entity"] = _entity.serialized()
	return data

func deserialize(data: Dictionary) -> AdventureTile:
	visibility = int(data["visibility"])
	_base_tile_id = int(data["base_id"])
	_details_tile_id = int(data["details_id"]) if data.has("details_id") else NO_TILE
	_entity = AdventureTileEntity.new(0, null).deserialize(data["entity"]) if data.has("entity") else null
	return self
