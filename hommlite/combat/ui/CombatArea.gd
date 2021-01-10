extends Node2D

export(Vector2) var overall_offset = Vector2.ZERO

onready var hexgrid: HexGrid = $HexGrid
onready var units = $VisibleUnits
onready var grid = $Grid
onready var action_resolver: CursorActionResolver = $CursorActionResolver
onready var keyboard = $Keyboard

var _battle: Battle
var _events: UIEvents

func setup_battle(battle: Battle, events: UIEvents):
	_battle = battle
	_events = events
	
	action_resolver.setup(battle, hexgrid)
	hexgrid.setup(battle.get_grid())
	grid.setup(hexgrid, battle, events, action_resolver)
	units.setup_units(battle)
	keyboard.setup(events)
	
	_center_self()
	units.reposition(hexgrid)


func _center_self():
	var win_w = ProjectSettings.get_setting("display/window/size/width")
	var win_h = ProjectSettings.get_setting("display/window/size/height")
	var grid_size = hexgrid.get_grid_size()
	var x = ((win_w - grid_size.x) / 2) + overall_offset.x
	var y = ((win_h - grid_size.y) / 2) + overall_offset.y

	set_position(Vector2(x, y))
	update()


func _on_Battle_stack_moved(stack: BattleStack, movement: BattleMovement):
	units.animate_move_stack(hexgrid, stack, movement, _events)

func _on_Battle_stack_attacked(source: BattleStack, target: BattleStack):
	units.animate_handle_attack(hexgrid, source, target, _events)
