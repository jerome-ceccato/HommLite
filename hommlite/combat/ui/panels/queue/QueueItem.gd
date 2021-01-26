class_name QueueItem
extends Control

onready var sprite: TextureRect = $TextureRect
onready var label: Label = $Label

var _log_helper: LogHelper

func setup(log_helper: LogHelper):
	_log_helper = log_helper


func update_with_stack(stack: BattleStack):
	if stack:
		sprite.texture = _get_texture(stack)
		
		label.text = str(stack.amount)
		if stack.side == BattleStack.Side.LEFT:
			label.add_color_override("font_color", _log_helper.player_color)
		else:
			label.add_color_override("font_color", _log_helper.enemy_color)
	else:
		sprite.texture = null
		label.text = ""


func _get_texture(stack: BattleStack) -> Texture:
	return load("res://assets/combat/units/%s.png" % [stack.stack.unit.id]) as Texture
