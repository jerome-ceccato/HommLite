class_name ArmyStackDisplay
extends Control

onready var sprite: TextureRect = $TextureRect
onready var label: Label = $Label


func update_with_stack(stack: Stack):
	if stack:
		sprite.texture = _get_texture(stack)
		label.text = str(stack.amount)
	else:
		sprite.texture = null
		label.text = ""


func _get_texture(stack: Stack) -> Texture:
	return load("res://assets/combat/units/%s.png" % [stack.load_unit().id]) as Texture
