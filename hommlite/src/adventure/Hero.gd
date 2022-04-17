extends Sprite

var map: AdventureMap

var _pos_hex: Vector3
var pos_hex: Vector3 setget set_position_hex, get_position_hex

func set_position_hex(pos: Vector3):
	_pos_hex = pos
	position = map.hexmap.hex_to_pixel(pos)

func get_position_hex() -> Vector3:
	return _pos_hex
