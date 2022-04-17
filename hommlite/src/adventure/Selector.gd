extends Sprite

signal adventure_tile_selected(hex)


var map: AdventureMap


func _process(delta):
	var hex = map.hexmap.pixel_to_hex(get_global_mouse_position())
	visible = map.hexmap.get_hex(hex) != null
	position = map.hexmap.hex_to_pixel(hex)


func _input(event):
	if event.is_action_pressed("adventure_reveal"):
		var hex = map.hexmap.pixel_to_hex(get_global_mouse_position())
		if map.hexmap.get_hex(hex):
			emit_signal("adventure_tile_selected", hex)
