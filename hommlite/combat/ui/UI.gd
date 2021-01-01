extends Node

onready var combat_area := $CombatArea
onready var cell_label := $CellLabel
onready var grid := $CombatArea/Grid
onready var battle_units := $CombatArea/VisibleUnits
onready var active_stack_overlay := $CombatArea/Grid/GridActiveStackOverlay

var battle: Battle
var queue: BattleQueue

func setup(_battle: Battle, _queue: BattleQueue):
	battle = _battle
	queue = _queue
	
	combat_area.setup_battle(battle)
	_setup_bindings()

func _setup_bindings():
	grid.connect("hex_grid_hovered", self, "_on_Grid_hex_grid_hovered")
	queue.connect("active_stack_changed", active_stack_overlay, "_on_BattleQueue_active_stack_changed")
	queue.connect("active_stack_changed", battle_units, "_on_BattleQueue_active_stack_changed")
	queue.connect("stack_moved", combat_area, "_on_BattleQueue_stack_moved")
	queue.connect("stack_moved", active_stack_overlay, "_on_BattleQueue_stack_moved")
	grid.connect("hex_cell_clicked", queue, "_on_Grid_hex_cell_clicked")

func _on_Grid_hex_grid_hovered(coords: BattleCoords, cell: HexCell):
	if cell != null:
		cell_label.text = "(%s, %s)" % [cell.coords.x, cell.coords.y]
	else:
		cell_label.text = ""
