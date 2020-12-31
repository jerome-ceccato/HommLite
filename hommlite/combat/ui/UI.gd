extends Node

onready var battlefield := $Battlefield
onready var cell_label := $CellLabel

var battle: Battle

func setup_ui(battle: Battle):
	self.battle = battle
	
	battlefield.setup_battle(battle)
	setup_bindings()

func setup_bindings():
	battlefield.grid_hover.connect("hex_grid_hovered", self, "_on_Grid_hex_grid_hovered")

func _on_Grid_hex_grid_hovered(cell: HexCell):
	if cell != null:
		cell_label.text = "(%s, %s)" % [cell.coords.x, cell.coords.y]
	else:
		cell_label.text = ""
