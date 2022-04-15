tool
extends Node
class_name HexMap

# Private properties
var _hex_grid = {}
var _orientation = layout_pointy
var _size: Vector2
var _origin: Vector2

# Public properties
var is_flat = false setget set_flat, get_flat
var layout_size = Vector2(10, 10) setget set_size, get_size
var origin = Vector2(0, 0) setget set_origin, get_origin

# Setters/Getters
func set_flat(is_flat):
	if is_flat:
		_orientation = layout_flat
	else:
		_orientation = layout_pointy

func get_flat(): 
	if _orientation == layout_flat:
		return true
	else:
		return false

func set_size(size): _size = size
func get_size(): return _size
func set_origin(origin): _origin = origin
func get_origin(): return _origin

# Initialise node, once we're ready

# An inner struct to represent a hex data + wall data
class HexData:
	var data
	var walls

# Layout Constants for verticies.
const layout_pointy = [sqrt(3.0), sqrt(3.0) / 2.0, 0.0, 3.0 / 2.0,
					   sqrt(3.0) / 3.0, -1.0 / 3.0, 0.0, 2.0 / 3.0,
					   0.5]

const layout_flat = [3.0 / 2.0, 0.0, sqrt(3.0) / 2.0, sqrt(3.0),
					 2.0 / 3.0, 0.0, -1.0 / 3.0, sqrt(3.0) / 3.0,
					 0.0]


func ready():
	_hex_grid = {}

# Add and removal w/ HexData wrapper
func add_hex(hex, data):
	if (_hex_grid.has(hex)):
		return
	var hd = HexData.new()
	hd.data = data
	hd.walls = []
	for i in range(5):
		hd.walls.push_back(null)
	_hex_grid[hex] = hd

func move_hex(hex_old, hex_new):
	if (_hex_grid.has(hex_new) || !_hex_grid.has(hex_old)):
		return
	_hex_grid[hex_new] = _hex_grid[hex_old]
	_hex_grid.erase(hex_old)

func remove_hex(hex):
	if (_hex_grid.has(hex)):
		_hex_grid.erase(hex)

func get_hex(hex):
	if (_hex_grid.has(hex)):
		return _hex_grid[hex].data

func get_all_hex():
	var hex_list = {}
	for coord in _hex_grid.keys():
		hex_list[coord] = _hex_grid[coord].data
	return hex_list

func get_wall(hex, direction):
	if (_hex_grid.has(hex)):
		return _hex_grid[hex].walls[direction]

# Rotation Transforms
func rotate_hex_left(hex):
	return Vector3(-hex.z, -hex.x, -hex.y);
func rotate_hex_right(hex):
	return Vector3(-hex.y, -hex.z, -hex.x);

# Pixel func and things useful to drawing.
func hex_to_pixel(hex: Vector3) -> Vector2:
	var x = (_orientation[0] * hex.x + _orientation[1] * hex.y) * _size.x
	var y = (_orientation[2] * hex.x + _orientation[3] * hex.y) * _size.y
	return Vector2(x + _origin.x, y + _origin.y);

func pixel_to_hex(pos: Vector2) -> Vector3:
	var pt = Vector2((pos.x - _origin.x) / _size.x,
				   (pos.y - _origin.y) / _size.y);
	var q = _orientation[4] * pt.x + _orientation[5] * pt.y;
	var r = _orientation[6] * pt.x + _orientation[7] * pt.y;
	return round_hex(Vector3(q, r, -q - r))

func round_hex(hex: Vector3) -> Vector3:
	var rx = round(hex.x)
	var ry = round(hex.y)
	var rz = round(hex.z)

	var x_diff = abs(rx - hex.x)
	var y_diff = abs(ry - hex.y)
	var z_diff = abs(rz - hex.z)

	if x_diff > y_diff and x_diff > z_diff:
		rx = -ry-rz
	elif y_diff > z_diff:
		ry = -rx-rz
	else:
		rz = -rx-ry

	return Vector3(rx, ry, rz)

func hex_corner_offset(corner: int) -> Vector2:
	var angle = 2.0 * PI * (_orientation[8] + corner) / 6;
	return Vector2(_size.x * cos(angle), _size.y * sin(angle));

func hex_corners(hex: Vector3) -> Array:
	var corners = [];
	var center = hex_to_pixel(hex);
	for i in range(7):
		var offset = hex_corner_offset(i);
		corners.push_back(Vector2(center.x + offset.x,
								center.y + offset.y));
	return corners

# Dicts of relative cube coordinates for directionals.
const hex_directions = [
	Vector3( 1, -1,  0), Vector3( 1,  0, -1), Vector3( 0,  1, -1),
	Vector3(-1,  1,  0), Vector3(-1,  0,  1), Vector3( 0, -1,  1)
]
const hex_diagonals = [
	Vector3( 2, -1, -1), Vector3( 1,  1, -2), Vector3(-1,  2, -1), 
	Vector3(-2,  1,  1), Vector3(-1, -1,  2), Vector3( 1, -2,  1)
]

# Return the coordinates of a direction from a given hex
func neighbor_hex(hex: Vector3, direction: int) -> Vector3:
	return hex + hex_directions[direction]
func diagonal_neighbor_hex(hex: Vector3, direction: int) -> Vector3:
	return hex + hex_diagonals[direction]

# Distance and from origin hex lengths.
func hex_length(hex: Vector3):
	return (abs(hex.x) + abs(hex.y) + abs(hex.z)) / 2;
func hex_distance(hex_a: Vector3, hex_b: Vector3):
	return hex_length(hex_a - hex_b);


func axial_to_oddq(hex: Vector3) -> Vector2:
	var col = hex.x
	var row = hex.y + (hex.x - (int(hex.x)&1)) / 2
	return Vector2(col, row)

func oddq_to_axial(coord: Vector2) -> Vector3:
	var q = coord.x
	var r = coord.y - (coord.x - (int(coord.x)&1)) / 2
	return Vector3(q, r, -q-r)
