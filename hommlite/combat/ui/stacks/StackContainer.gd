class_name StackContainer
extends Node2D

onready var _sprite: Sprite = $Sprite
onready var _tween: Tween = $Tween
onready var _stack_count_container: Sprite = $StackCount
onready var _stack_count_label: Label = $StackCount/Label

var stack: BattleStack


func setup_with_stack(_stack: BattleStack):
	stack = _stack
	
	_stack_count_label.text = str(stack.amount)
	if stack.side == stack.Side.RIGHT:
		_sprite.flip_h = true
		_stack_count_container.position.x = -(32 + _stack_count_container.position.x)


func set_active(active: bool):
	_sprite.material.set_shader_param("enabled", active)


func animate_through_points(points: Array, flying: bool):
	if flying:
		_tween.interpolate_property(
			self,
			"position",
			position,
			points[-1],
			animation_time(points),
			Tween.TRANS_SINE,
			Tween.EASE_IN_OUT
		)
		_tween.start()
	else:
		var single_point_duration = 0.1
		for point in points:
			_tween.interpolate_property(
				self,
				"position",
				position,
				point,
				single_point_duration,
				Tween.TRANS_SINE,
				Tween.EASE_IN_OUT
			)
			_tween.start()
			yield(_tween, "tween_completed")


func animation_time(points: Array):
	var single_point_duration = 0.1
	return single_point_duration * points.size()


func animate_death() -> float:
	visible = false
	return 0.0


func animate_refresh() -> float:
	_stack_count_label.text = str(stack.amount)
	return 0.0
