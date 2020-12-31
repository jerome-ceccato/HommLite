extends Node2D

signal hex_grid_hovered(coords, cell)

onready var background := $GridBackground
onready var hover := $GridHover
onready var movement_overlay := $GridMovementOverlay

var hexgrid: HexGrid
var battle: Battle

var last_hovered_cell_coords

func setup(_hexgrid: HexGrid, _battle: Battle):
	hexgrid = _hexgrid
	battle = _battle
	
	background.setup(hexgrid)
	hover.setup(hexgrid)
	movement_overlay.setup(hexgrid, battle)
	
	connect("hex_grid_hovered", hover, "_on_Grid_hex_grid_hovered")
	connect("hex_grid_hovered", movement_overlay, "_on_Grid_hex_grid_hovered")

func _process(_delta):
	var mouse_pos = get_local_mouse_position()
	var hovered_cell_coords = hexgrid.get_cell_index_at_point(mouse_pos)
	
	if last_hovered_cell_coords != hovered_cell_coords:
		last_hovered_cell_coords = hovered_cell_coords
		var hovered_cell = hexgrid.get_cell(hovered_cell_coords) if hovered_cell_coords != null else null
		
		emit_signal("hex_grid_hovered", hovered_cell_coords, hovered_cell)
