extends Node
class_name AdventureTileEntity

enum EntityTileID {
	NO_TILE = -1,
	HOME = 0,
	ENEMY = 1,
	ENEMY2 = 2,
}

var _is_home: bool
var _enemy_id: String

func as_home() -> AdventureTileEntity:
	_is_home = true
	_enemy_id = ""
	return self

func as_enemy(id: String) -> AdventureTileEntity:
	_is_home = false
	_enemy_id = id
	return self

func from_tilemap(tile_id: int) -> AdventureTileEntity:
	match tile_id:
		EntityTileID.HOME:
			return as_home()
		EntityTileID.ENEMY:
			return as_enemy("test")
		EntityTileID.ENEMY2:
			return as_enemy("test-hard")
	return null


func is_home():
	return _is_home

func is_enemy():
	return !_is_home

func get_enemy_id():
	return _enemy_id

func get_tile_id():
	if _is_home:
		return EntityTileID.HOME
	else:
		match _enemy_id:
			"test":
				return EntityTileID.ENEMY
			"test-hard":
				return EntityTileID.ENEMY2
	return EntityTileID.NO_TILE


func serialized() -> Dictionary:
	return {
		"_is_home": _is_home,
		"_enemy_id": _enemy_id,
	}

func deserialize(data: Dictionary) -> AdventureTileEntity:
	_is_home = data["_is_home"]
	_enemy_id = data["_enemy_id"]
	return self
