class_name CursorState
extends Node

# Pre-calculates the action to be represented depending on the cursor position
# to be used throughout the UI and passed down to the logic if needed
# This only applies the the combat area

enum Action {
	NONE, # not targetting a hex cell
	UNREACHABLE_CELL, # an empty cell that is unreacheable for the active stack
	REACHABLE_CELL, # an empty cell that is reacheable for the active stack
	UNREACHABLE_STACK, # a stack that the active stack cannot attack (ally or unreachable)
	REACHABLE_STACK, # an enemy stack that can be attacked
	RANGED_REACHABLE_STACK, # an enemy stack that can be attacked by ranged attack, without moving
}

var action: int
var mouse_pos: Vector2
var hovered_cell_coords: BattleCoords
var active_stack: BattleStack
var target_stack: BattleStack
var hover_hex_cells: Array #[HexCell]
