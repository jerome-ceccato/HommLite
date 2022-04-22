extends Node
class_name AdventureTileBuilding

enum TileID {
	HOME = 0,
}

func get_tile_id() -> int:
	return TileID.HOME

