extends Node2D

onready var tilemap: TileMap = $TileMap
onready var hexmap: HexMap = $TileMap/HexMap


func _ready():
	_setup_hexmap()
	_procedural_init()
	
	$Selector.hexmap = hexmap
	$Selector.tilemap = tilemap
	$Debug.hexmap = hexmap


func _setup_hexmap():
	var cell_size = tilemap.cell_size
	hexmap.set_flat(true)
	hexmap.set_origin(Vector2(-cell_size.x / 2 - 0.5, -0.5))
	hexmap.set_size(Vector2(
		cell_size.x / 1.5, 
		cell_size.y / (2 * sin(PI/3))
	))


func _init_from_tilemap():
	for cell in tilemap.get_used_cells():
		var hex_pos = hexmap.oddq_to_axial(cell)
		hexmap.add_hex(hex_pos, {})


func _procedural_init():
	tilemap.clear()
	
	var noise = _procedural_setup()
	var radius = 16
	for q in range(-radius, radius + 1):
		var r1 = max(-radius, -q - radius)
		var r2 = min(radius, -q + radius)
		for r in range(r1, r2 + 1):
			var hex = Vector3(q, r, -q-r)
			var tilemap_coords = hexmap.axial_to_oddq(hex)
			var tile_id = _procedural_get_tile(hex, noise)
			var tile = AdventureTile.new(tile_id, hexmap.hex_length(hex) < 2)
			hexmap.add_hex(hex, tile)
			tilemap.set_cell(tilemap_coords.x, tilemap_coords.y, tile.get_tile_id())

func _procedural_get_tile(hex: Vector3, noise):
	var value = noise.get_noise_2d(hex.x, hex.y)
	if value < -0.3:
		return 1
	elif value > 0.3:
		return 2
	else:
		return 0

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
