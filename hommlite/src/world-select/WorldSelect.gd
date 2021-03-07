extends Node2D

onready var _start_button: DefaultButton = $WorldSelect/StartButton

var _all_cards: Array
var _selected_world: WorldData

func _ready():
	_all_cards = [
		$WorldSelect/Cards/LeftCard,
		$WorldSelect/Cards/CenterCard,
		$WorldSelect/Cards/RightCard
	]
	
	_setup_cards()
	_setup_army()
	_start_button.set_active(false)


func _setup_cards():
	var data = [
		WorldData.new("Earth", "res://assets/ui/previews/earth.png", "easy", "Reward:\n100 souls"),
		WorldData.new("Mars", "res://assets/ui/previews/mars.png", "medium", "Reward:\n300 souls"),
		WorldData.new("HAT-P-1b", "res://assets/ui/previews/hatp1b.png", "hard", "Reward:\n800 souls"),
	]
	
	for card in _all_cards:
		card.connect("card_selected", self, "_on_card_selected")

	for i in range(data.size()):
		_all_cards[i].setup(data[i])


func _setup_army():
	var stacks = Context.player_army.stacks
	var stack_displays = $WorldSelect/GridContainer.get_children()
	
	for i in range(stack_displays.size()):
		var stack = stacks[i] if i < stacks.size() else null
		stack_displays[i].update_with_stack(stack)


func _on_card_selected(selected_card):
	for card in _all_cards:
		card.set_selected(card == selected_card)
		if card == selected_card:
			_selected_world = card.world
	_start_button.set_active(true)


func _on_CloseButton_pressed():
	queue_free()


func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		queue_free()


func _on_StartButton_pressed():
	Context.current_world = CurrentWorld.new(_selected_world)
	Context.load_battle()
	_start_combat()


func _start_combat():
	var combat_scene_path = "res://src/combat/CombatScene.tscn"
	get_tree().change_scene(combat_scene_path)
