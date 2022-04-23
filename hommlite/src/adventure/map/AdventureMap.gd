extends Node2D
class_name AdventureMap

onready var baseTilemap: TileMap = $BaseTileMap
onready var detailsTilemap: TileMap = $DetailsTileMap
onready var entityTilemap: TileMap = $EntityTileMap
onready var outlineTilemap: TileMap = $OutlineTileMap
onready var hexmap: HexMap = $HexMap


func get_data() -> AdventureMapData:
	return Context.save_data.map


func reveal(hex: Vector3, do_neighbors: bool):
	_reveal_hex(hex, AdventureTileVisibility.VISIBLE)
	if do_neighbors:
		for direction in range(6):
			_reveal_hex(hexmap.neighbor_hex(hex, direction), AdventureTileVisibility.FOG)

func _reveal_hex(hex: Vector3, visibility: int):
	var tile: AdventureTile = get_data().get_hex(hex)
	if tile:
		if tile.visibility < visibility:
			tile.visibility = visibility
			_update_tile_in_tilemap(tile, hex)


func discard_entity(hex: Vector3):
	var tile: AdventureTile = get_data().get_hex(hex)
	if tile:
		tile.delete_entity()
		_update_tile_in_tilemap(tile, hex)


func regenerate():
	_procedural_init()


func _ready():
	_setup_hexmap()
	if Context.has_save():
		_load_save()
	else:
		_load_from_editor()
	$DebugHexMapDrawer.map = hexmap


func _setup_hexmap():
	var cell_size = baseTilemap.cell_size
	hexmap.set_flat(true)
	hexmap.set_origin(Vector2(-cell_size.x / 2 + 1, 1))
	hexmap.set_size(Vector2(
		cell_size.x / 1.5, 
		cell_size.y / (2 * sin(PI/3))
	))


func _load_from_editor():
	get_data().clear()
	for cell in baseTilemap.get_used_cells():
		var hex_pos = hexmap.oddq_to_axial(cell)
		get_data().set_hex(hex_pos, AdventureTile.new(
			baseTilemap.get_cellv(cell),
			detailsTilemap.get_cellv(cell),
			_entity_from_tilemap(entityTilemap.get_cellv(cell)),
			AdventureTileVisibility.VISIBLE if hexmap.hex_length(hex_pos) < 2 else AdventureTileVisibility.HIDDEN
		))
	_reload_tilemaps()

func _entity_from_tilemap(id: int) -> AdventureTileEntity:
	match id:
		AdventureTileBuilding.TileID.HOME:
			return AdventureTileEntity.new(AdventureTileEntity.Type.BUILDING, AdventureTileBuilding.new())
		AdventureTileEnemy.TileID.ENEMY, AdventureTileEnemy.TileID.ENEMY2:
			return AdventureTileEntity.new(AdventureTileEntity.Type.ENEMY, AdventureTileEnemy.new(id, Army.new({
				0: Stack.new("chicken", 20)
			})))
	return null


func _procedural_init():
	get_data().clear()
	Context.save_data.map.tiles = $AdventureMapGenerator.gen_hexmap(hexmap, 16)
	_reload_tilemaps()


func _load_save():
	_reload_tilemaps()


func _reload_tilemaps():
	for tilemap in [baseTilemap, detailsTilemap, entityTilemap, outlineTilemap]:
		tilemap.clear()
	
	var all_hex = get_data().get_all_hex()
	for hex in all_hex:
		var tile = all_hex[hex]
		_update_tile_in_tilemap(tile, hex)


func _update_tile_in_tilemap(tile: AdventureTile, hex: Vector3):
	var tilemap_coords = hexmap.axial_to_oddq(hex)
	
	baseTilemap.set_cell(tilemap_coords.x, tilemap_coords.y, tile.get_base_tile_id())
	detailsTilemap.set_cell(tilemap_coords.x, tilemap_coords.y, tile.get_details_tile_id())
	entityTilemap.set_cell(tilemap_coords.x, tilemap_coords.y, tile.get_entity_tile_id())
	outlineTilemap.set_cell(tilemap_coords.x, tilemap_coords.y, tile.get_outline_tile_id())

