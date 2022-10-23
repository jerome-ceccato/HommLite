class_name AnyActionButton
extends Node2D

@export var display_name: String

@onready var _button: TextureButton = $TextureButton
var _active := true

func is_hovered() -> bool:
	return _active and _button.is_hovered()


func set_active(active: bool):
	_active = active
	_button.disabled = !active
	modulate.a = 1.0 if active else 0.5
