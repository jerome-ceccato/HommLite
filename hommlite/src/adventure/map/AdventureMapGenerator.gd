extends Node
class_name AdventureMapGenerator

var rng: RandomNumberGenerator
var simplexNoise: OpenSimplexNoise

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()


func gen_hexmap(hexmap: HexMap, radius: int):
	_setup_noise()
	for q in range(-radius, radius + 1):
		var r1 = max(-radius, -q - radius)
		var r2 = min(radius, -q + radius)
		for r in range(r1, r2 + 1):
			var hex = Vector3(q, r, -q-r)
			hexmap.add_hex(hex, _gen_tile(hexmap, hex, radius))


func _setup_noise():
	simplexNoise = OpenSimplexNoise.new()
	simplexNoise.seed = rng.randi()
	simplexNoise.octaves = 3
	simplexNoise.period = 16.0
	simplexNoise.persistence = 0.5
	simplexNoise.lacunarity = 3


func _gen_tile(hexmap: HexMap, hex: Vector3, radius: int) -> AdventureTile:
	var noise_value = simplexNoise.get_noise_2d(hex.x, hex.y)
	var distance = hexmap.hex_length(hex)
	
	if distance == radius:
		return AdventureTile.new(
			AdventureTile.BaseTileID.MOUNTAIN2, 
			AdventureTile.NO_TILE, 
			AdventureTile.NO_TILE, 
			false
		)
	elif distance < 2:
		var home = AdventureTile.EntityTileID.HOME if distance == 0 else AdventureTile.NO_TILE
		return AdventureTile.new(AdventureTile.BaseTileID.GRASS, AdventureTile.NO_TILE, home, true)
	else:
		return AdventureTile.new(
			_gen_base_tile(hex, noise_value), 
			_gen_details_tile(hex, noise_value),
			_gen_entity_tile(hex, noise_value),
			false
		)


func _gen_base_tile(hex: Vector3, value: float) -> int:
	if value < -0.3:
		return AdventureTile.BaseTileID.WATER2 if value > -0.5 else AdventureTile.BaseTileID.WATER
	elif value > 0.3:
		return AdventureTile.BaseTileID.MOUNTAIN if value < 0.5 else AdventureTile.BaseTileID.MOUNTAIN2
	else:
		return AdventureTile.BaseTileID.GRASS if value > 0 else AdventureTile.BaseTileID.GRASS2


func _gen_details_tile(hex: Vector3, value: float) -> int:
	if value > 0 && value < 0.1:
		return AdventureTile.DetailTileID.FLOWER
	return AdventureTile.NO_TILE


func _gen_entity_tile(hex: Vector3, value: float) -> int:
	if value > -0.3 && value < 0.3:
		if rng.randi() % 8 == 1:
			return AdventureTile.EntityTileID.ENEMY
	return AdventureTile.NO_TILE
