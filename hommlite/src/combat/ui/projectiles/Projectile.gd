class_name Projectile
extends Node2D

onready var _tween: Tween = $Tween

func animate(from: Vector2, to: Vector2):
	position = from
	
	var duration = abs(from.distance_to(to)) / 3000
	_tween.interpolate_property(
		self,
		"position",
		position,
		to,
		duration,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT_IN
	)
	_tween.start()
	yield(_tween, "tween_completed")
	queue_free()
