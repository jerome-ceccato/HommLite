@tool
extends Node2D

@export var font: Font
@export var color: Color = Color.BEIGE

var hexgrid: CombatHexGrid


func setup(_hexgrid: CombatHexGrid):
	hexgrid = _hexgrid


func _draw():
	for cell in hexgrid.all_cells():
		var offset = Vector2(-10, 8)
		var coords_text = "%s,%s" % [cell.coords.x, cell.coords.y]
		#void draw_string(font: Font, pos: Vector2, text: String, alignment: HorizontalAlignment = 0, width: float = -1, font_size: int = 16, modulate: Color = Color(1, 1, 1, 1), jst_flags: JustificationFlag = 3, direction: Direction = 0, orientation: Orientation = 0) const
		draw_string(font, cell.center + offset, coords_text, 0, -1, 16, color)
