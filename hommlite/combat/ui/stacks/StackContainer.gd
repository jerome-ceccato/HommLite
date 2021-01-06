class_name StackContainer
extends Node2D

onready var _sprite: Sprite = $Sprite
onready var _tween: Tween = $Tween

var stack: BattleStack


func setup_with_stack(_stack: BattleStack):
	stack = _stack
	if stack.side == stack.Side.RIGHT:
		_sprite.flip_h = true


func set_active(active: bool):
	_sprite.material.set_shader_param("enabled", active)


func animate_to_position(pos: Vector2) -> float:
	var duration = 0.5
	_tween.interpolate_property(
		self,
		"position",
		position,
		pos,
		duration,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	_tween.start()
	return duration


func animate_death() -> float:
	visible = false
	return 0.0
