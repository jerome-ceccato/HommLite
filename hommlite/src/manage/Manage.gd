extends Node2D

onready var _textbox: RichTextLabel = $ManageArmy/RichTextLabel
onready var _input: LineEdit = $ManageArmy/LineEdit
onready var _interpretor: ManageArmyInterpretor = $ManageArmyInterpretor


func _ready():
	_interpretor.setup(_textbox)
	_update_army()


func _update_army():
	var stacks = Context.player_army.stacks
	var stack_displays = $ManageArmy/HBoxContainer.get_children()
	
	for i in range(stack_displays.size()):
		var stack = stacks[i] if i < stacks.size() else null
		stack_displays[i].update_with_stack(stack)


func _on_CloseButton_pressed():
	queue_free()


func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		queue_free()


func _on_LineEdit_text_entered(new_text):
	if _interpretor.handle(new_text):
		_input.clear()
		_update_army()
