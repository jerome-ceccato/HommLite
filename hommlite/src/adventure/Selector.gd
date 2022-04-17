extends Sprite

var map: AdventureMap


func _process(delta):
	var hex = map.hexmap.pixel_to_hex(get_global_mouse_position())
	visible = map.hexmap.get_hex(hex) != null
	position = map.hexmap.hex_to_pixel(hex)


func _input(event):
	if event.is_action_pressed("adventure_reveal"):
		var hex = map.hexmap.pixel_to_hex(get_global_mouse_position())
		map.reveal(hex)
		for direction in range(6):
			map.reveal(map.hexmap.neighbor_hex(hex, direction))
