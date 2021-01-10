extends Node2D

onready var battle: Battle = $Battle
onready var ui = $UI

onready var battle_events: BattleEvents = $Battle/BattleEvents
onready var ui_events: UIEvents = $UI/UIEvents

var left_army: ArmyData
var right_army: ArmyData

func _ready():
	left_army = ArmyData.new([
		StackData.new(UnitFactory.bee(), 1),
		StackData.new(UnitFactory.bee(), 26),
		StackData.new(UnitFactory.uchicken(), 8),
	])
	
	right_army = ArmyData.new([
		StackData.new(UnitFactory.chicken(), 1),
		StackData.new(UnitFactory.bee(), 4),
		StackData.new(UnitFactory.chicken(), 422),
	])
	
	battle.setup_battle(left_army, right_army)
	ui.setup(battle)
	
	
	_setup_bindings()
	_run()


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
