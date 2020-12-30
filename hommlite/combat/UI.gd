extends Node

onready var grid := $Grid
onready var cell_label := $CellLabel

var battlefield: BattleField

func setup_ui(battlefield: BattleField):
	self.battlefield = battlefield
	
	grid.setup_battle(battlefield)
	setup_bindings()

func setup_bindings():
	grid.connect("hex_grid_hovered", self, "_on_Grid_hex_grid_hovered")

func _on_Grid_hex_grid_hovered(cell: HexCell):
	if cell != null:
		cell_label.text = "(%s, %s)" % [cell.coords.x, cell.coords.y]
	else:
		cell_label.text = ""
