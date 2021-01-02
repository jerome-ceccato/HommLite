extends Label

func _on_UI_hex_grid_hovered(coords: BattleCoords, cell: HexCell):
	if cell != null:
		text = "(%s, %s)" % [cell.coords.x, cell.coords.y]
	else:
		text = ""
