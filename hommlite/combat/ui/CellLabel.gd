extends RichTextLabel

var hexgrid: HexGrid


func setup(hexgrid: HexGrid):
	self.hexgrid = hexgrid


func _on_UI_mouse_moved(state: CursorState):
	var cell = state.hover_hex_cell
	var content = ""
	if cell != null:
		content = "(%s, %s)" % [cell.coords.x, cell.coords.y]
		var stack = state.target_stack
		if stack:
			var unit = stack.stack.unit
			content += "\n%s: %s-%s (%s)" % [unit.id, unit.attack_low, unit.attack_high, unit.hp]
			content += "\n%s units, %s hp" % [stack.amount, stack.top_unit_hp]
	
	text = content
