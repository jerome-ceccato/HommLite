extends Node
class_name AdventureMapGenerator

var rng = RandomNumberGenerator.new()
var simplexNoise = OpenSimplexNoise.new()

func _ready():
	rng.randomize()
	simplexNoise.seed = rng.randi()
	simplexNoise.octaves = 3
	simplexNoise.period = 16.0
	simplexNoise.persistence = 0.5
	simplexNoise.lacunarity = 3


func gen_hexmap(hexmap: HexMap, radius: int):
	for q in range(-radius, radius + 1):
		var r1 = max(-radius, -q - radius)
		var r2 = min(radius, -q + radius)
		for r in range(r1, r2 + 1):
			var hex = Vector3(q, r, -q-r)
			hexmap.add_hex(hex, _gen_tile(hexmap, hex, radius))


func _gen_tile(hexmap: HexMap, hex: Vector3, radius: int) -> AdventureTile:
	var noise_value = simplexNoise.get_noise_2d(hex.x, hex.y)
	var distance = hexmap.hex_length(hex)
	
	if distance == radius:
		return AdventureTile.new(2, -1, -1, false)
	elif distance < 2:
		var home = 0 if distance == 0 else -1
		return AdventureTile.new(0, -1, home, true)
	else:
		return AdventureTile.new(
			_gen_base_tile(hex, noise_value), 
			_gen_details_tile(hex, noise_value),
			_gen_entity_tile(hex, noise_value),
			false
		)


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


func _gen_entity_tile(hex: Vector3, value: float) -> int:
	if value > -0.3 && value < 0.3:
		if rng.randi() % 8 == 1:
			return 1
	return -1
