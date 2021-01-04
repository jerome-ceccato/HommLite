extends Label

var hexgrid: HexGrid


func setup(hexgrid: HexGrid):
	self.hexgrid = hexgrid


func _on_UI_mouse_moved(state: CursorState):
	var cell = state.hover_hex_cell
	if cell != null:
		text = "(%s, %s)" % [cell.coords.x, cell.coords.y]
	else:
		text = ""
