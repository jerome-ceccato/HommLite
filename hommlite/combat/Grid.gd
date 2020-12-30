extends Node2D

signal hex_grid_hovered

onready var hexgrid := $HexGrid
onready var units := $Units

var _hovered_cell

func setup_battle(left: Army, right: Army):
	units.setup_armies(left, right, hexgrid.get_size())
	
	reposition_armies()
	update()

func reposition_armies():
	reposition_army(units.left_army)
	reposition_army(units.right_army)
	
func reposition_army(army: Army):
	for stack in army.stacks:
		stack.sprite.position = hexgrid.get_cell(stack.position).center

func _ready():
	var win_w = ProjectSettings.get_setting("display/window/size/width")
	var win_h = ProjectSettings.get_setting("display/window/size/height")
	var grid_size = hexgrid.get_grid_size()
	var origin = Vector2((win_w - grid_size.x) / 2, (win_h - grid_size.y) / 2)
	set_position(origin)
	
func _draw():
	if _hovered_cell != null:
		var color = Color.black
		color.a = 0.2
		draw_polygon(_hovered_cell.points, [color])
	
	for cell in hexgrid.cells.values():
		draw_polyline(cell.points, Color.beige, 1, true)
	

func _process(delta):
	var mouse_pos = get_local_mouse_position()
	var new_cell = hexgrid.get_cell_at_point(mouse_pos)
	if _hovered_cell != new_cell:
		_hovered_cell = new_cell
		emit_signal("hex_grid_hovered", new_cell)
		update()
