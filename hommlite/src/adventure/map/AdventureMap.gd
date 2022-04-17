extends Node2D
class_name AdventureMap

onready var baseTilemap: TileMap = $BaseTileMap
onready var detailsTilemap: TileMap = $DetailsTileMap
onready var hexmap: HexMap = $HexMap


func reveal(hex: Vector3):
	var hexdata = hexmap.get_hex(hex)
	if hexdata:
		hexdata.revealed = true
		var tilemap_coords = hexmap.axial_to_oddq(hex)
		baseTilemap.set_cell(tilemap_coords.x, tilemap_coords.y, hexdata.get_base_tile_id())
		detailsTilemap.set_cell(tilemap_coords.x, tilemap_coords.y, hexdata.get_details_tile_id())


func _ready():
	_setup_hexmap()
	_procedural_init()


func _setup_hexmap():
	var cell_size = baseTilemap.cell_size
	hexmap.set_flat(true)
	hexmap.set_origin(Vector2(-cell_size.x / 2 - 0.5, -0.5))
	hexmap.set_size(Vector2(
		cell_size.x / 1.5, 
		cell_size.y / (2 * sin(PI/3))
	))


func _init_from_tilemap():
	for cell in baseTilemap.get_used_cells():
		var hex_pos = hexmap.oddq_to_axial(cell)
		hexmap.add_hex(hex_pos, {})


func _procedural_init():
	baseTilemap.clear()
	
	var noise = _procedural_setup()
	var radius = 16
	for q in range(-radius, radius + 1):
		var r1 = max(-radius, -q - radius)
		var r2 = min(radius, -q + radius)
		for r in range(r1, r2 + 1):
			var hex = Vector3(q, r, -q-r)
			_set_tile(hex, noise)


func _set_tile(hex: Vector3, noise):
	var noise_value = noise.get_noise_2d(hex.x, hex.y)
	var tilemap_coords = hexmap.axial_to_oddq(hex)
	
	var tile = AdventureTile.new(
		_gen_base_tile(hex, noise_value), 
		_gen_details_tile(hex, noise_value),
		hexmap.hex_length(hex) < 2
		#true
	)
	
	hexmap.add_hex(hex, tile)
	baseTilemap.set_cell(tilemap_coords.x, tilemap_coords.y, tile.get_base_tile_id())
	detailsTilemap.set_cell(tilemap_coords.x, tilemap_coords.y, tile.get_details_tile_id())


func _gen_base_tile(hex: Vector3, value: float) -> int:
	if value < -0.3:
		return 1
	elif value > 0.3:
		return 2
	else:
		return 0

func _gen_details_tile(hex: Vector3, value: float) -> int:
	if value > 0 && value < 0.1:
		return 0
	return -1


func _procedural_setup():
	var rng = RandomNumberGenerator.new()
	var simplexNoise = OpenSimplexNoise.new()
	rng.randomize()
	simplexNoise.seed = rng.randi()
	simplexNoise.octaves = 3
	simplexNoise.period = 16.0
	simplexNoise.persistence = 0.5
	simplexNoise.lacunarity = 3
	return simplexNoise
