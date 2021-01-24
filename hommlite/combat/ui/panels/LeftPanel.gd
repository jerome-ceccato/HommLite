extends Node2D

onready var wait_button = $WaitButton
onready var def_button = $DefButton

var events: UIEvents


func setup(_events: UIEvents):
	events = _events

func _on_Wait_pressed():
	events.emit_signal("action_wait")

func _on_Def_pressed():
	events.emit_signal("action_skip")
