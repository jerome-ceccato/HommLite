extends Node2D

onready var tilemap: TileMap = $TileMap
onready var hexmap: HexMap = $TileMap/HexMap


func _ready():
	_setup_hexmap()
	_init_from_tilemap()
	
	var hex = Vector3(1,1,-2)
	print(hex)
	var pixel_from_hex = hexmap.hex_to_pixel(hex)
	print(pixel_from_hex)
	var local_pixel_from_hex = tilemap.to_local(pixel_from_hex)
	print(local_pixel_from_hex)
	var tilemap_coords = tilemap.world_to_map(local_pixel_from_hex)
	print(tilemap_coords)
	var local_pixel_from_tilemap = tilemap.map_to_world(tilemap_coords)
	print(local_pixel_from_tilemap)
	var pixel_from_tilemap = tilemap.to_global(local_pixel_from_tilemap)
	print(pixel_from_tilemap)
	var new_hex = hexmap.pixel_to_hex(pixel_from_tilemap)
	print(new_hex)
	print("---")
	print(hexmap.hex_to_pixel(Vector3(0,0,0)))
	print(tilemap.to_global(tilemap.map_to_world(Vector2(0,0))))
	
	$Selector.hexmap = hexmap


func _setup_hexmap():
	var cell_size = tilemap.cell_size
	hexmap.set_flat(true)
	hexmap.set_origin(Vector2(-cell_size.x / 2 - 0.5, -0.5))
	hexmap.set_size(Vector2(
		cell_size.x / 1.5, 
		cell_size.y / (2 * sin(PI/3))
	))


func _init_from_tilemap():
	for cell in tilemap.get_used_cells():
		var hex_pos = hexmap.oddq_to_axial(cell)
		#var hex_pos = hexmap.pixel_to_hex(tilemap.map_to_world(cell))
		hexmap.add_hex(hex_pos, {})


func _procedural_init():
	tilemap.clear()
	
	var radius = 3
	for q in range(-radius, radius + 1):
		var r1 = max(-radius, -q - radius)
		var r2 = min(radius, -q + radius)
		for r in range(r1, r2 + 1):
			var hex = Vector3(q, r, -q-r)
			hexmap.add_hex(hex, {})
			#var tilemap_coords = tilemap.world_to_map(tilemap.to_local(hexmap.hex_to_pixel(hex)))
			var tilemap_coords = hexmap.axial_to_oddq(hex)
			tilemap.set_cell(tilemap_coords.x, tilemap_coords.y, 0)


func _draw():
	for hex in hexmap.get_all_hex():
		draw_polygon(hexmap.hex_corners(hex), [Color.red])


func _process(delta):
	var hex = hexmap.pixel_to_hex(get_global_mouse_position())
	var oddq = hexmap.axial_to_oddq(hex)
	if hexmap.get_hex(hex) != null:
		$CanvasLayer/Position.text = "%s\n%s" % [hex, oddq]
	else:
		$CanvasLayer/Position.text = ""
