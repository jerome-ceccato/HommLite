class_name StackContainer
extends Node2D

onready var _sprite: AnimatedSprite = $Sprite
onready var _tween: Tween = $Tween
onready var _stack_count_container: Sprite = $StackCount
onready var _stack_count_label: Label = $StackCount/Label

const TURN_ANIMATION_DURATION = 0.3
const MOVE_ANIMATION_DURATION = 0.3

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
	_sprite.play()
	if flying:
		var destination = points[-1]
		_flip_towards(destination)
		_animate_sprite(destination, animation_time(points))
		yield(_tween, "tween_completed")
	else:
		for point in points:
			_flip_towards(point)
			_animate_sprite(point, MOVE_ANIMATION_DURATION)
			yield(_tween, "tween_completed")
	_sprite.stop()
	_sprite.frame = 0
	_reset_flip()


func animation_time(points: Array):
	return MOVE_ANIMATION_DURATION * points.size()


func animate_death() -> float:
	visible = false
	return 0.0


func animate_refresh() -> float:
	_stack_count_label.text = str(stack.amount)
	return 0.0


func _reset_flip():
	_sprite.flip_h = stack.side == stack.Side.RIGHT


func _flip_towards(destination: Vector2):
	var flipped = destination.x < position.x
	_sprite.flip_h = flipped


func _animate_turn(duration: float):
	_tween.interpolate_property(
		_sprite,
		"flip_h",
		_sprite.flip_h,
		!_sprite.flip_h,
		duration,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	_tween.start()

func _animate_sprite(to: Vector2, duration: float):
	_tween.interpolate_property(
		self,
		"position",
		position,
		to,
		duration,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	_tween.start()
