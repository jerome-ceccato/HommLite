extends Node

onready var cell_label := $CellLabel

func _on_Grid_hex_grid_hovered(cell: HexCell):
	if cell != null:
		cell_label.text = "(%s, %s)" % [cell.coords.x, cell.coords.y]
	else:
		cell_label.text = ""
		
