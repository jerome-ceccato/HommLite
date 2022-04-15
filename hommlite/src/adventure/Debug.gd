extends Node2D

var hexmap: HexMap

func _process(delta):
	var hex = hexmap.pixel_to_hex(get_global_mouse_position())
	var oddq = hexmap.axial_to_oddq(hex)
	if hexmap.get_hex(hex) != null:
		$CanvasLayer/Position.text = "%s\n%s" % [hex, oddq]
	else:
		$CanvasLayer/Position.text = ""
