extends Sprite

var map: AdventureMap

func set_position_hex(pos: Vector3):
	position = map.hexmap.hex_to_pixel(pos)
