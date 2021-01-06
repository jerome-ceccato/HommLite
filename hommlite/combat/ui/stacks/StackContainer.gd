class_name StackContainer
extends Node2D

onready var _sprite: Sprite = $Sprite
onready var _tween: Tween = $Tween
onready var _stack_count_container: Sprite = $StackCount
onready var _stack_count_label: Label = $StackCount/Label

var stack: BattleStack


func setup_with_stack(_stack: BattleStack):
	stack = _stack
	
	_sprite.texture = load("res://assets/combat/units/%s.png" % stack.stack.unit.id)
	_stack_count_label.text = str(stack.stack.amount)
	if stack.side == stack.Side.RIGHT:
		_sprite.flip_h = true
		_stack_count_container.position.x = -(32 + _stack_count_container.position.x)


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
