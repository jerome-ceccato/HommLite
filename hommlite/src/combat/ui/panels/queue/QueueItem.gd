class_name QueueItem
extends Control

@onready var sprite: TextureRect = $TextureRect
@onready var label: Label = $Label

@onready var round_container: Control = $NextRound
@onready var round_number: Label = $NextRound/Label

var _log_helper: LogHelper

func setup(log_helper: LogHelper):
	_log_helper = log_helper


func update_with_stack(stack: BattleStack):
	round_container.visible = false
	if stack:
		sprite.texture = _get_texture(stack)
		
		label.text = str(stack.amount)
		if stack.side == BattleStack.Side.LEFT:
			label.add_theme_color_override("font_color", _log_helper.player_color)
		else:
			label.add_theme_color_override("font_color", _log_helper.enemy_color)
	else:
		sprite.texture = null
		label.text = ""


func update_with_round_number(n: int):
	round_container.visible = true
	sprite.texture = null
	label.text = ""
	round_number.text = str(n)


func _get_texture(stack: BattleStack) -> Texture2D:
	return load("res://assets/combat/units/%s.png" % [stack.unit.id]) as Texture2D
