extends Resource
class_name AdventureMapData

# Represents an adventure map and its metadata (tiles, hero pos)

var tiles := {}
var player_pos := Vector3.ZERO

func get_hex(hex: Vector3) -> AdventureTile:
	return tiles.get(hex)

func set_hex(hex: Vector3, tile: AdventureTile):
	tiles[hex] = tile

func get_all_hex() -> Dictionary:
	return tiles

func clear():
	tiles = {}


func serialized() -> Dictionary:
	return {
		"tiles": _serialized_tiles(tiles),
		"player_pos": var2str(player_pos),
	}

func deserialize(data: Dictionary) -> AdventureMapData:
	tiles = _deserialized_tiles(data["tiles"])
	player_pos = str2var(data["player_pos"])
	return self


func _serialized_tiles(dict: Dictionary):
	var serialized = {}
	for key in dict:
		serialized[var2str(key)] = dict[key].serialized()
	return serialized

func _deserialized_tiles(dict: Dictionary):
	var serialized = {}
	for key in dict:
		serialized[str2var(key)] = AdventureTile.new(0,0,null,0).deserialize(dict[key])
	return serialized
