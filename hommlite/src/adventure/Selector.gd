extends Sprite

var hexmap: HexMap
var tilemap: TileMap


func _process(delta):
	var hex = hexmap.pixel_to_hex(get_global_mouse_position())
	visible = hexmap.get_hex(hex) != null
	position = hexmap.hex_to_pixel(hex)


func _input(event):
	if event.is_action_pressed("adventure_reveal"):
		var hex = hexmap.pixel_to_hex(get_global_mouse_position())
		_reveal(hex)
		for direction in range(6):
			_reveal(hexmap.neighbor_hex(hex, direction))


func _reveal(hex: Vector3):
	var hexdata = hexmap.get_hex(hex)
	if hexdata:
		hexdata.revealed = true
		var tilemap_coords = hexmap.axial_to_oddq(hex)
		tilemap.set_cell(tilemap_coords.x, tilemap_coords.y, hexdata.get_tile_id())
