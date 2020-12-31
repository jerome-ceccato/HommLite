extends Node2D

signal hex_grid_hovered

export(int) var hex_cell_size := 32
onready var units := $Units

var battle: Battle
var hexgrid: HexGrid

var _hovered_cell

func setup_battle(battle: Battle):
	self.battle = battle
	hexgrid = HexGrid.new(hex_cell_size, battle.size())
	
	units.setup_units(battle)
	units.reposition(hexgrid)

	var win_w = ProjectSettings.get_setting("display/window/size/width")
	var win_h = ProjectSettings.get_setting("display/window/size/height")
	var grid_size = hexgrid.get_grid_size()
	var origin = Vector2((win_w - grid_size.x) / 2, (win_h - grid_size.y) / 2)
	set_position(origin)
	
	update()
	
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
