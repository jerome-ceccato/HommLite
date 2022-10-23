extends Node2D

onready var armyContainer := $CanvasLayer/PanelContainer/VBoxContainer/ArmyContainer

func refresh():
	_setup_army()
	_load_souls()


func _ready():
	refresh()


func _setup_army():
	var stacks = Context.save_data.hero.army.stacks
	var stack_displays = armyContainer.get_children()
	
	for i in range(stack_displays.size()):
		var stack = stacks[i] if stacks.has(i) else null
		stack_displays[i].update_with_stack(stack)

func _load_souls():
	$CanvasLayer/PanelContainer/VBoxContainer/Souls.text = "Gold: %d" % Context.save_data.resources.gold

