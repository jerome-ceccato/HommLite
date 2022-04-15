extends Node2D

onready var tilemap: TileMap = $TileMap
onready var hexmap: HexMap = $TileMap/HexMap

func _ready():
	var cell_size = tilemap.cell_size
	hexmap.set_flat(true)
	hexmap.set_origin(Vector2(-cell_size.x / 2 - 0.5, -0.5))
	hexmap.set_size(Vector2(
		cell_size.x / 1.5, 
		cell_size.y / (2 * sin(PI/3))
	))
	
	for cell in tilemap.get_used_cells():
		var pos = tilemap.map_to_world(cell)
		var hex_pos = hexmap.pixel_to_hex(pos)
		hexmap.add_hex(hex_pos, {})
	
	$Selector.hexmap = hexmap
