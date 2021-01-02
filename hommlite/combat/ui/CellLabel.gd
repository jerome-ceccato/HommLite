extends Label

var hexgrid: HexGrid


func setup(hexgrid: HexGrid):
	self.hexgrid = hexgrid


func _on_UI_hex_grid_hovered(coords: BattleCoords):
	var cell = hexgrid.get_cell_at_coords(coords) if coords != null else null
	if cell != null:
		text = "(%s, %s)" % [cell.coords.x, cell.coords.y]
	else:
		text = ""
