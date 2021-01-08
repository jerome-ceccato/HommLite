extends Node2D

onready var battle: Battle = $Battle
onready var ui = $UI

onready var battle_events: BattleEvents = $Battle/BattleEvents
onready var ui_events: UIEvents = $UI/UIEvents

var left_army: ArmyData
var right_army: ArmyData

func _ready():
	left_army = ArmyData.new([
		StackData.new(UnitFactory.chicken(), 50),
		StackData.new(UnitFactory.bee(), 8),
		StackData.new(UnitFactory.uchicken(), 3),
	])
	
	right_army = ArmyData.new([
		StackData.new(UnitFactory.chicken(), 100),
		StackData.new(UnitFactory.bee(), 4),
	])
	
	battle.setup_battle(left_army, right_army)
	ui.setup(battle)
	
	_setup_bindings()
	_run()


func _setup_bindings():
	for listener in [
		$UI/CombatArea/Grid/ActionGridHover, 
		$UI/CombatArea/Grid/UnitHoverMovementOverlay,
		$UI/CellLabel,
		$UI/Cursor,
		]:
		ui_events.connect("mouse_moved", listener, "_on_UI_mouse_moved")
	
	for listener in [$Battle/BattleQueue]:
		ui_events.connect("mouse_clicked", listener, "_on_UI_mouse_clicked")
	
	for listener in [
		$UI/CombatArea/Grid/ActiveStackMovementOverlay,
		$UI/CombatArea/VisibleUnits,
		$UI/CombatArea/Grid, 
		]:
		battle_events.connect("active_stack_changed", listener, "_on_Battle_active_stack_changed")
	
	for listener in [$UI/CombatArea]:
		battle_events.connect("stack_moved", listener, "_on_Battle_stack_moved")
		battle_events.connect("stack_damaged", listener, "_on_Battle_stack_damaged")
		battle_events.connect("stack_destroyed", listener, "_on_Battle_stack_destroyed")
	
	for listener in [$UI/Dialogs]:
		battle_events.connect("game_ended", listener, "_on_Battle_game_ended")
	
	ui_events.connect("animation_finished", self, "_on_animation_finished")


func _run():
	battle.queue.run()


func _on_animation_finished():
	battle_events.emit_signal("resume")
