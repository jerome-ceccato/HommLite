class_name Projectile
extends Node2D

@onready var _tween := create_tween()

func animate(from: Vector2, to: Vector2):
	position = from
	var duration = abs(from.distance_to(to)) / 3000
	_tween.tween_property(
		self,
		"position",
		to,
		duration
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT_IN)
	await _tween.finished
	queue_free()
