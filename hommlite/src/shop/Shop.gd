extends Node2D


func _ready():
	_setup_army()


func _setup_army():
	var stacks = Context.player_army.stacks
	var stack_displays = $Shop/GridContainer.get_children()
	
	for i in range(stack_displays.size()):
		var stack = stacks[i] if i < stacks.size() else null
		stack_displays[i].update_with_stack(stack)


func _on_CloseButton_pressed():
	queue_free()


func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		queue_free()
