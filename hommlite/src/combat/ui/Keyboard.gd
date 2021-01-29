extends Node

var events: UIEvents


func setup(_events: UIEvents):
	events = _events


func _input(event):
	if event.is_action_pressed("combat_skip"):
		events.emit_signal("action_skip")
	elif event.is_action_pressed("combat_wait"):
		events.emit_signal("action_wait")
