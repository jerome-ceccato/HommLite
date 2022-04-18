extends Node2D

var map: AdventureMap

func _process(delta):
	var hex = map.hexmap.pixel_to_hex(get_global_mouse_position())
	var oddq = map.hexmap.axial_to_oddq(hex)
	if map.hexmap.get_hex(hex) != null:
		$CanvasLayer/Position.text = "%s - %s" % [hex, oddq]
	else:
		$CanvasLayer/Position.text = ""


func _on_Reveal_pressed():
	for hex in map.hexmap.get_all_hex().keys():
		map.reveal(hex)


func _on_Regen_pressed():
	map.regenerate()
	_on_Reveal_pressed()


func _on_Screenshot_pressed():
	var now = OS.get_datetime()
	var now_str = "%d-%d-%d_%d.%d.%d" % [now["year"], now["month"], now["day"], now["hour"], now["minute"], now["second"]]
	var ss = get_viewport().get_texture().get_data()
	ss.flip_y()
	ss.save_png("user://ss-%s.png" % now_str)
