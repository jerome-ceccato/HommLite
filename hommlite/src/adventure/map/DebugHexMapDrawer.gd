extends Node2D

var map: HexMap

func _draw():
	for hex in Context.save_data.map.get_all_hex():
		draw_polygon(map.hex_corners(hex), [Color.red])
