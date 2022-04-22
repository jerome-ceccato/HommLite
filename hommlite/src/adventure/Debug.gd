extends Node2D

var map: AdventureMap

onready var cursorPosition := $CanvasLayer/PanelContainer/VBoxContainer/Position
onready var armyContainer := $CanvasLayer/PanelContainer/VBoxContainer/ArmyContainer

func refresh():
	_setup_army()
	_load_souls()
	if map:
		_update_cursor_pos()


func _ready():
	refresh()


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		_update_cursor_pos()


func _update_cursor_pos():
	var hex = map.hexmap.pixel_to_hex(get_global_mouse_position())
	var oddq = map.hexmap.axial_to_oddq(hex)
	if map.hexmap.get_hex(hex) != null:
		cursorPosition.text = "%s - %s" % [hex, oddq]
	else:
		cursorPosition.text = "empty"

func _setup_army():
	var stacks = Context.player_army.stacks
	var stack_displays = armyContainer.get_children()
	
	for i in range(stack_displays.size()):
		var stack = stacks[i] if stacks.has(i) else null
		stack_displays[i].update_with_stack(stack)

func _load_souls():
	$CanvasLayer/PanelContainer/VBoxContainer/Souls.text = "Souls: %d" % Context.souls


func _on_Reveal_pressed():
	for hex in map.hexmap.get_all_hex().keys():
		map.reveal(hex, false)


func _on_Regen_pressed():
	map.regenerate()
	get_parent().get_node("Hero").set_position_hex(Vector3.ZERO)


func _on_Screenshot_pressed():
	var now = OS.get_datetime()
	var now_str = "%d-%d-%d_%d.%d.%d" % [now["year"], now["month"], now["day"], now["hour"], now["minute"], now["second"]]
	var ss = get_viewport().get_texture().get_data()
	ss.flip_y()
	ss.save_png("user://ss-%s.png" % now_str)
