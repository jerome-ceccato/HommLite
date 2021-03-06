extends Node2D

var _all_cards: Array

func _ready():
	_all_cards = [
		$WorldSelect/Cards/LeftCard,
		$WorldSelect/Cards/CenterCard,
		$WorldSelect/Cards/RightCard
	]
	
	for card in _all_cards:
		card.connect("card_selected", self, "_on_card_selected")
	_setup_cards()


func _setup_cards():
	var data = [
		WorldData.new("Earth", "res://assets/ui/previews/earth.png", "easy", "Reward:\n100 souls"),
		WorldData.new("Mars", "res://assets/ui/previews/mars.png", "medium", "Reward:\n300 souls"),
		WorldData.new("HAT-P-1b", "res://assets/ui/previews/hatp1b.png", "hard", "Reward:\n800 souls"),
	]
	
	for i in range(3):
		_all_cards[i].setup(data[i])


func _on_card_selected(selected_card):
	for card in _all_cards:
		card.set_selected(card == selected_card)


func _on_CloseButton_pressed():
	queue_free()


func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		queue_free()
