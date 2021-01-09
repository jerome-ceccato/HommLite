extends Node2D

signal hex_grid_hovered(coords, cell)
signal hex_cell_clicked(coords)

onready var background = $GridBackground
onready var hover = $ActionGridHover
onready var movement_overlay = $UnitHoverMovementOverlay
onready var active_stack_overlay = $ActiveStackMovementOverlay

var hexgrid: HexGrid
var battle: Battle
var events: UIEvents
var action_resolver: CursorActionResolver


func setup(_hexgrid: HexGrid, _battle: Battle, _events: UIEvents, _action_resolver: CursorActionResolver):
	hexgrid = _hexgrid
	battle = _battle
	events = _events
	action_resolver = _action_resolver
	
	background.setup(hexgrid)
	hover.setup(battle, hexgrid)
	movement_overlay.setup(hexgrid, battle)
	active_stack_overlay.setup(hexgrid, battle)


func _on_Battle_game_state_changed(battle: Battle):
	match battle.get_state():
		BattleData.State.IN_PROGRESS:
			events.emit_signal("mouse_moved", _get_current_state())
		BattleData.State.COMBAT_ENDED:
			hover.visible = false
			active_stack_overlay.visible = false
			movement_overlay.visible = false


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			events.emit_signal("mouse_clicked", _get_current_state())
	elif event is InputEventMouseMotion:
		var mouse_pos = get_local_mouse_position()
		var hovered_cell_coords = hexgrid.get_cell_coords_at_point(mouse_pos)
		
		events.emit_signal("mouse_moved", _get_current_state())


func _get_current_state() -> CursorState:
	return action_resolver.get_state(get_local_mouse_position())
