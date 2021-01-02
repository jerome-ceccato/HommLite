extends Node2D

onready var hexgrid: HexGrid = $HexGrid
onready var units = $VisibleUnits
onready var grid = $Grid

var battle: Battle

func setup_battle(battle: Battle, events: UIEvents):
	self.battle = battle
	
	hexgrid.setup(battle.grid)
	grid.setup(hexgrid, battle, events)
	units.setup_units(battle)
	
	_center_self()
	units.reposition(hexgrid)


func _center_self():
	var win_w = ProjectSettings.get_setting("display/window/size/width")
	var win_h = ProjectSettings.get_setting("display/window/size/height")
	var grid_size = hexgrid.get_grid_size()
	var origin = Vector2((win_w - grid_size.x) / 2, (win_h - grid_size.y) / 2)
	set_position(origin)
	
	update()


func _on_Battle_stack_moved(stack: BattleStack, previous_position: BattleCoords):
	units.reposition(hexgrid)
