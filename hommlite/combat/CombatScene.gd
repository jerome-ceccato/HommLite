extends Node2D

onready var battle: Battle = $Battle
onready var ui = $UI

onready var battle_events: BattleEvents = $Battle/BattleEvents
onready var ui_events: UIEvents = $UI/UIEvents

func _ready():	
	var armies = _make_armies()
	battle.setup_battle(armies[0], armies[1])
	ui.setup(battle)
	
	
	_setup_bindings()
	_run()


func _make_armies() -> Array:
	var bee = load("res://assets/data/bee.tres")
	var chicken = load("res://assets/data/chicken.tres")
	var uchicken = load("res://assets/data/uchicken.tres")
	
	var left_army = ArmyData.new([
		StackData.new(bee, 1),
		StackData.new(bee, 26),
		StackData.new(uchicken, 8),
	])
	
	var right_army = ArmyData.new([
		StackData.new(chicken, 1),
		StackData.new(bee, 23),
		StackData.new(chicken, 165),
	])
	
	return [left_army, right_army]


func _setup_bindings():
	for listener in [
		$UI/CombatArea/Grid/ActionGridHover, 
		$UI/CombatArea/Grid/UnitHoverMovementOverlay,
		$UI/Cursor,
		]:
		ui_events.connect("mouse_moved", listener, "_on_UI_mouse_moved")
	
	for listener in [$Battle/BattleManager]:
		ui_events.connect("mouse_clicked", listener, "_on_UI_mouse_clicked")
	
	for listener in [$Battle/BattleManager]:
		ui_events.connect("action_skip", listener, "_on_UI_action_skip")
	
	for listener in [$Battle/BattleManager]:
		ui_events.connect("action_wait", listener, "_on_UI_action_wait")
	
	for listener in [$UI/CombatArea]:
		battle_events.connect("stack_moved", listener, "_on_Battle_stack_moved")
		battle_events.connect("stack_attacked", listener, "_on_Battle_stack_attacked")
	
	for listener in [
		$UI/Dialogs,
		$UI/Cursor,
		$UI/CombatArea/Grid,
		$UI/CombatArea/VisibleUnits,
		$UI/CombatArea/Grid/ActionGridHover,
		$UI/CombatArea/Grid/ActiveStackMovementOverlay,
		]:
		battle_events.connect("game_state_changed", listener, "_on_Battle_game_state_changed")
	
	for listener in [$UI/BottomPanel/CombatLogs]:
		battle_events.connect("new_combat_log", listener, "_on_Battle_new_combat_log")
	
	ui_events.connect("animation_finished", self, "_on_animation_finished")


func _run():
	battle.run()


func _on_animation_finished():
	battle_events.emit_signal("resume")
