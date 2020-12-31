extends Node2D

export(int) var hex_cell_size := 32

onready var units := $BattleUnits
onready var grid := $Grid

var battle: Battle
var hexgrid: HexGrid

func setup_battle(battle: Battle):
	self.battle = battle
	hexgrid = HexGrid.new(hex_cell_size, battle.size())
	
	center_self(hexgrid)
	
	grid.setup(hexgrid, battle)
	units.setup_units(battle)
	
	units.reposition(hexgrid)

func center_self(hexgrid: HexGrid):
	var win_w = ProjectSettings.get_setting("display/window/size/width")
	var win_h = ProjectSettings.get_setting("display/window/size/height")
	var grid_size = hexgrid.get_grid_size()
	var origin = Vector2((win_w - grid_size.x) / 2, (win_h - grid_size.y) / 2)
	set_position(origin)
	
	update()
