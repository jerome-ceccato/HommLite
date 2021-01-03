extends Node2D

signal hex_grid_hovered(coords, cell)
signal hex_cell_clicked(coords)

onready var background = $GridBackground
onready var hover = $ActionGridHover
onready var movement_overlay = $UnitHoverMovementOverlay
onready var active_stack_overlay = $ActiveStackMovementOverlay

var hexgrid: HexGrid
var battle: Battle
var events: UIEvents

var _last_hovered_cell_coords


func setup(_hexgrid: HexGrid, _battle: Battle, _events: UIEvents):
	hexgrid = _hexgrid
	battle = _battle
	events = _events
	
	background.setup(hexgrid)
	hover.setup(battle, hexgrid)
	movement_overlay.setup(hexgrid, battle)
	active_stack_overlay.setup(hexgrid, battle)


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			var clicked_cell_coords = hexgrid.get_cell_coords_at_point(get_local_mouse_position())
			if clicked_cell_coords != null:
				events.emit_signal("hex_cell_clicked", clicked_cell_coords)
	elif event is InputEventMouseMotion:
		var mouse_pos = get_local_mouse_position()
		var hovered_cell_coords = hexgrid.get_cell_coords_at_point(mouse_pos)
		
		_last_hovered_cell_coords = hovered_cell_coords
		events.emit_signal("hex_cell_hovered", hovered_cell_coords)
