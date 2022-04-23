extends Sprite

signal adventure_tile_selected(hex)


var map: AdventureMap


func _unhandled_input(event):
	if event.is_action_pressed("adventure_reveal"):
		var hex = map.hexmap.pixel_to_hex(get_global_mouse_position())
		if map.get_data().get_hex(hex):
			emit_signal("adventure_tile_selected", hex)
	elif event is InputEventMouseMotion:
		_refresh_position()


func _refresh_position():
	var hex = map.hexmap.pixel_to_hex(get_global_mouse_position())
	visible = map.get_data().get_hex(hex) != null
	position = map.hexmap.hex_to_pixel(hex)
