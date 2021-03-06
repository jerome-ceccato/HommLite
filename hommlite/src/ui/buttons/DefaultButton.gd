class_name DefaultButton
extends Button

var _active := true


func set_active(active: bool):
	_active = active
	disabled = !active
	modulate.a = 1 if active else 0.5
