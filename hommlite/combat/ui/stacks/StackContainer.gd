class_name StackContainer
extends Node2D

onready var _sprite: AnimatedSprite = $Sprite
onready var _sprite_anim: AnimationPlayer = $SpriteAnimation
onready var _world_anim: Tween = $WorldAnimation

onready var _stack_count_container: Node2D = $StackCount
onready var _stack_count_label: Label = $StackCount/Label

const TURN_ANIMATION_DURATION = 0.3
const MOVE_ANIMATION_DURATION = 0.3
const ATTACK_ANIMATION_DURATION = 0.3
const DEATH_ANIMATION_DURATION = 0.4

var stack: BattleStack


func setup_with_stack(_stack: BattleStack):
	stack = _stack
	
	_stack_count_label.text = str(stack.amount)
	if stack.side == BattleStack.Side.RIGHT:
		_sprite.flip_h = true
	set_active(false)


func set_active(active: bool):
	if active:
		_sprite_anim.play("ActiveOutline")
	else:
		_sprite_anim.stop(true)
		_sprite.material.set_shader_param("outline_width", 0.0)


func animate_through_points(points: Array, flying: bool):
	_stack_count_container.visible = false
	_sprite.play()
	if flying:
		var destination = points[-1]
		_flip_towards(destination)
		_animate_sprite(destination, animation_time_for_movement(points))
		yield(_world_anim, "tween_completed")
	else:
		for point in points:
			_flip_towards(point)
			_animate_sprite(point, MOVE_ANIMATION_DURATION)
			yield(_world_anim, "tween_completed")
	
	_reset_flip()
	_sprite.stop()
	_sprite.frame = 0
	_stack_count_container.visible = true

func animate_death(source: StackContainer):
	_play_sided_animation("Death", source)
	yield(get_tree().create_timer(animation_time_for_death()), "timeout")
	z_index = 0


func animate_damaged(source: StackContainer):
	_play_sided_animation("Damage", source)
	_stack_count_label.text = str(stack.amount)


func animate_attack(target: StackContainer):
	var should_be_flipped = position.x > target.position.x
	if should_be_flipped != _sprite.flip_h:
		_sprite.flip_h = should_be_flipped
		yield(get_tree().create_timer(animation_time_for_damage()), "timeout")
		_sprite.flip_h = !should_be_flipped
		


func animation_time_for_movement(points: Array) -> float:
	return MOVE_ANIMATION_DURATION * points.size() + 0.1

func animation_time_for_damage():
	return ATTACK_ANIMATION_DURATION

func animation_time_for_death():
	return DEATH_ANIMATION_DURATION


func _reset_flip():
	_sprite.flip_h = stack.side == BattleStack.Side.RIGHT


func _flip_towards(destination: Vector2):
	var flipped = destination.x < position.x
	_sprite.flip_h = flipped


func _animate_turn(duration: float):
	_world_anim.interpolate_property(
		_sprite,
		"flip_h",
		_sprite.flip_h,
		!_sprite.flip_h,
		duration,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	_world_anim.start()

func _animate_sprite(to: Vector2, duration: float):
	_world_anim.interpolate_property(
		self,
		"position",
		position,
		to,
		duration,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	_world_anim.start()


func _play_sided_animation(animation: String, source: StackContainer):
	var side = "Left" if source.position.x > position.x else "Right"
	_sprite_anim.play(animation + side)
