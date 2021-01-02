class_name HexUtils

# Hex operations
# Adapted from https://www.redblobgames.com/grids/hexagons

static func nearby_coords(origin: BattleCoords, distance: int) -> Array:
	var center = oddr_to_cube(origin)
	var results = []
	for x in range(-distance, distance + 1):
		for y in range(max(-distance, -x - distance), min(distance, -x + distance) + 1):
			var z = -x - y
			var cube = center + Vector3(x, y, z)
			results.append(cube_to_oddr(cube))
	return results


static func cube_round(cube: Vector3):
	var rx = round(cube.x)
	var ry = round(cube.y)
	var rz = round(cube.z)
	
	var x_diff = abs(rx - cube.x)
	var y_diff = abs(ry - cube.y)
	var z_diff = abs(rz - cube.z)

	if x_diff > y_diff and x_diff > z_diff:
		rx = -ry - rz
	elif y_diff > z_diff:
		ry = -rx - rz
	else:
		rz = -rx - ry

	return Vector3(rx, ry, rz)


static func cube_to_oddr(cube: Vector3):
	var x = int(cube.x)
	var z = int(cube.z)
	var col = x + (z - (z & 1)) / 2
	var row = z
	return BattleCoords.new(col, row)


static func oddr_to_cube(hex: BattleCoords):
	var x = hex.x - (hex.y - (hex.y & 1)) / 2
	var z = hex.y
	var y = -x - z
	return Vector3(x, y, z)
