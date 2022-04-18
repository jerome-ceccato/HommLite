extends Node2D
class_name AdventureMap

onready var baseTilemap: TileMap = $BaseTileMap
onready var detailsTilemap: TileMap = $DetailsTileMap
onready var entityTilemap: TileMap = $EntityTileMap
onready var outlineTilemap: TileMap = $OutlineTileMap
onready var hexmap: HexMap = $HexMap


func reveal(hex: Vector3):
	var tile: AdventureTile = hexmap.get_hex(hex)
	if tile:
		tile.revealed = true
		_update_tile_in_tilemap(tile, hex)


func discard_entity(hex: Vector3):
	var tile: AdventureTile = hexmap.get_hex(hex)
	if tile:
		tile.delete_entity()
		_update_tile_in_tilemap(tile, hex)


func regenerate():
	_procedural_init()


func _ready():
	_setup_hexmap()
	_procedural_init()
	$DebugHexMapDrawer.map = hexmap


func _setup_hexmap():
	var cell_size = baseTilemap.cell_size
	hexmap.set_flat(true)
	hexmap.set_origin(Vector2(-cell_size.x / 2 + 1, 1))
	hexmap.set_size(Vector2(
		cell_size.x / 1.5, 
		cell_size.y / (2 * sin(PI/3))
	))


func _procedural_init():
	hexmap.clear()
	for tilemap in [baseTilemap, detailsTilemap, entityTilemap, outlineTilemap]:
		tilemap.clear()
	
	$AdventureMapGenerator.gen_hexmap(hexmap, 32)
	var all_hex = hexmap.get_all_hex()
	for hex in all_hex:
		var tile = all_hex[hex]
		_update_tile_in_tilemap(tile, hex)


func _update_tile_in_tilemap(tile: AdventureTile, hex: Vector3):
	var tilemap_coords = hexmap.axial_to_oddq(hex)
	
	baseTilemap.set_cell(tilemap_coords.x, tilemap_coords.y, tile.get_base_tile_id())
	detailsTilemap.set_cell(tilemap_coords.x, tilemap_coords.y, tile.get_details_tile_id())
	entityTilemap.set_cell(tilemap_coords.x, tilemap_coords.y, tile.get_entity_tile_id())
	outlineTilemap.set_cell(tilemap_coords.x, tilemap_coords.y, tile.get_outline_tile_id())
