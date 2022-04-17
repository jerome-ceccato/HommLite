extends Node2D

var map: AdventureMap

func _process(delta):
	var hex = map.hexmap.pixel_to_hex(get_global_mouse_position())
	var oddq = map.hexmap.axial_to_oddq(hex)
	if map.hexmap.get_hex(hex) != null:
		$CanvasLayer/Position.text = "%s\n%s" % [hex, oddq]
	else:
		$CanvasLayer/Position.text = ""
