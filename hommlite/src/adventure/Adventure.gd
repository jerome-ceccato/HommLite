extends Node2D

onready var hexmap: HexMap = $TileMap/HexMap

func _ready():
	var cell_size = $TileMap.cell_size
	hexmap.set_flat(true)
	hexmap.set_origin(Vector2(-cell_size.x / 2 - 0.5, -0.5))
	hexmap.set_size(Vector2(
		cell_size.x / 1.5, 
		cell_size.y / (2 * sin(PI/3))
	))
	
	$Selector.hexmap = hexmap
