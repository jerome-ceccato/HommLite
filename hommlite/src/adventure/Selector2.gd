extends Node2D

var hexmap: HexMap

func _process(delta):
	update()
	
func _draw():
	var hex = hexmap.pixel_to_hex(get_global_mouse_position())
	var lines = hexmap.hex_corners(hex)
	draw_polygon(lines, [Color.red])
	draw_polyline(lines, Color.white)
