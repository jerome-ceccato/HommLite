extends Sprite

var hexmap: HexMap

func _process(delta):
	var hex = hexmap.pixel_to_hex(get_global_mouse_position())
	position = hexmap.hex_to_pixel(hex)
