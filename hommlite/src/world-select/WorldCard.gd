class_name WorldCard
extends Control

signal card_selected(card)

onready var _background: TextureRect = $Background

onready var _texture_default = preload("res://assets/ui/world-card-bg.png")
onready var _texture_selected = preload("res://assets/ui/world-card-selected-bg.png")

func setup(data: WorldData):
	$WorldName.text = data.name
	$WorldPreview.texture = load(data.preview_ref)
	$Difficulty.text = data.difficulty
	$Reward.text = data.rewards

func set_selected(selected: bool):
	if selected:
		_background.texture = _texture_selected
	else:
		_background.texture = _texture_default

func _on_select_pressed():
	emit_signal("card_selected", self)
