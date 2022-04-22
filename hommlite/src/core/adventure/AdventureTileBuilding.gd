extends Reference
class_name AdventureTileBuilding

# Represents the metadata for a building entity in the map

enum TileID {
	HOME = 0,
}

func get_tile_id() -> int:
	return TileID.HOME

