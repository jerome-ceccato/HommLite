extends Node2D

onready var battle: Battle = $Battle
onready var ui = $UI

onready var battle_events: BattleEvents = $Battle/BattleEvents
onready var ui_events: UIEvents = $UI/UIEvents

var left_army: ArmyData
var right_army: ArmyData

func _ready():
	left_army = _create_army([
		StackData.new(UnitFactory.chicken(), 50),
		StackData.new(UnitFactory.bee(), 8),
		StackData.new(UnitFactory.chicken(), 10),
		StackData.new(UnitFactory.chicken(), 20),
		StackData.new(UnitFactory.chicken(), 30),
	])
	
	right_army = _create_army([
		StackData.new(UnitFactory.chicken(), 100),
		StackData.new(UnitFactory.bee(), 1),
	])
	
	battle.setup_battle(left_army, right_army)
	ui.setup(battle)
	
	_setup_bindings()
	_run()


func _setup_bindings():
	for hover_listener in [
		$UI/CombatArea/Grid/ActionGridHover, 
		$UI/CombatArea/Grid/UnitHoverMovementOverlay,
		$UI/CellLabel,
		$UI/Cursor,
		]:
		ui_events.connect("mouse_moved", hover_listener, "_on_UI_mouse_moved")
	
	for click_listener in [$Battle/BattleQueue]:
		ui_events.connect("mouse_clicked", click_listener, "_on_UI_mouse_clicked")
	
	for active_stack_listener in [
		$UI/CombatArea/Grid/ActiveStackMovementOverlay,
		$UI/CombatArea/VisibleUnits,
		$UI/CombatArea/Grid, 
		]:
		battle_events.connect("active_stack_changed", active_stack_listener, "_on_Battle_active_stack_changed")
	
	for combat_events_listener in [
		$UI/CombatArea,
		]:
		battle_events.connect("stack_moved", combat_events_listener, "_on_Battle_stack_moved")
		battle_events.connect("stack_damaged", combat_events_listener, "_on_Battle_stack_damaged")
		battle_events.connect("stack_destroyed", combat_events_listener, "_on_Battle_stack_destroyed")
		
	
	ui_events.connect("animation_finished", self, "_on_animation_finished")

func _run():
	battle.queue.run()


func _create_army(units: Array) -> ArmyData:
	return ArmyData.new(units)

func _on_animation_finished():
	$Battle/BattleEvents.emit_signal("resume")
