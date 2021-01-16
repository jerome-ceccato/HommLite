extends Node2D

onready var wait_button = $WaitButton
onready var skip_button = $SkipButton

var events: UIEvents


func setup(_events: UIEvents):
	events = _events


func _ready():
	wait_button.connect("pressed", self, "_on_wait_pressed")
	skip_button.connect("pressed", self, "_on_skip_pressed")


func _on_wait_pressed():
	events.emit_signal("action_wait")

func _on_skip_pressed():
	events.emit_signal("action_skip")
