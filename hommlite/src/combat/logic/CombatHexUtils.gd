@tool
class_name CombatHexUtils

# Hex operations
# Adapted from https://www.redblobgames.com/grids/hexagons

static func nearby_coords(origin: BattleCoords, valid_coords: Dictionary, distance: int) -> Array:
	var center = oddr_to_cube(origin)
	var results = []
	for x in range(-distance, distance + 1):
		for y in range(max(-distance, -x - distance), min(distance, -x + distance) + 1):
			var z = -x - y
			var cube = center + Vector3(x, y, z)
			var coord = cube_to_oddr(cube)
			if valid_coords.has(coord.index):
				results.append(coord)
	return results


static func reachable_coords(origin: BattleCoords, valid_coords: Dictionary, distance: int, blocked: Array, large: bool) -> Array:
	var visited = {}
	var blocked_lookup = {}
	var fringes = []
	visited[origin.index] = origin
	fringes.append([origin])
	
	for coords in blocked:
		blocked_lookup[coords.index] = coords
	
	for k in range(1, distance + 1):
		fringes.append([])
		for hex in fringes[k - 1]:
			for dir in range(6):
				var neighbor = oddr_offset_neighbor(hex, dir)
				if _can_visit_neighbor(neighbor, hex, visited, blocked_lookup, valid_coords, large):
					visited[neighbor.index] = neighbor
					fringes[k].append(neighbor)
	return visited.values()


static func _can_visit_neighbor(neighbor: BattleCoords, from: BattleCoords, visited: Dictionary, blocked: Dictionary, valid: Dictionary, large: bool) -> bool:
	if large:
		if visited.has(neighbor.index) or blocked.has(neighbor.index) or !valid.has(neighbor.index):
			return false
		if from.y != neighbor.y:
			var xoffset = neighbor.x - from.x
			if from.y & 1:
				xoffset -= 1
			
			if xoffset < 0:
				var left_row = BattleCoords.new(from.x - 1, from.y)
				var y_row = BattleCoords.new(neighbor.x + 1, neighbor.y)
				var left_blocked = blocked.has(left_row.index) or !valid.has(left_row.index)
				var y_blocked = blocked.has(y_row.index) or !valid.has(y_row.index)
				return !left_blocked or !y_blocked
			else:
				var right_row = BattleCoords.new(from.x + 1, from.y)
				var y_row = BattleCoords.new(neighbor.x - 1, neighbor.y)
				var right_blocked = blocked.has(right_row.index) or !valid.has(right_row.index)
				var y_blocked = blocked.has(y_row.index) or !valid.has(y_row.index)
				return !right_blocked or !y_blocked
		return true
	else:
		return !visited.has(neighbor.index) and !blocked.has(neighbor.index) and valid.has(neighbor.index)


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


static func oddr_offset_neighbor(hex: BattleCoords, direction: int):
	var oddr_directions = [
		[[+1,  0], [ 0, -1], [-1, -1], 
		[-1,  0], [-1, +1], [ 0, +1]],
		[[+1,  0], [+1, -1], [ 0, -1], 
		[-1,  0], [ 0, +1], [+1, +1]],
	]
	var parity = hex.y & 1
	var dir = oddr_directions[parity][direction]
	return BattleCoords.new(hex.x + dir[0], hex.y + dir[1])
