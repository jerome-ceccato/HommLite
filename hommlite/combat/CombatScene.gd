extends Node2D

onready var battle: Battle = $Battle
onready var ui = $UI

onready var battle_events: BattleEvents = $Battle/BattleEvents
onready var ui_events: UIEvents = $UI/UIEvents

var left_army: ArmyData
var right_army: ArmyData

func _ready():
	left_army = _create_army([
		UnitFactory.chicken(),
	])
	
	right_army = _create_army([
		UnitFactory.blob(),
		UnitFactory.chicken(),
		UnitFactory.blob(),
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
		$UI/Cursor
		]:
		ui_events.connect("mouse_moved", hover_listener, "_on_UI_mouse_moved")
	
	for click_listener in [$Battle/BattleQueue]:
		ui_events.connect("mouse_clicked", click_listener, "_on_UI_mouse_clicked")
	
	for active_stack_listener in [
		$UI/CombatArea/Grid/ActiveStackMovementOverlay,
		$UI/CombatArea/VisibleUnits,
		]:
		battle_events.connect("active_stack_changed", active_stack_listener, "_on_Battle_active_stack_changed")
	
	for stack_moved_listener in [
		$UI/CombatArea,
		]:
		battle_events.connect("stack_moved", stack_moved_listener, "_on_Battle_stack_moved")
	
	for stack_destroyed_listener in [
		$UI/CombatArea,
		]:
		battle_events.connect("stack_destroyed", stack_destroyed_listener, "_on_Battle_stack_destroyed")
	
	ui_events.connect("animation_finished", self, "_on_animation_finished")

func _run():
	battle.queue.run()


func _create_army(units: Array) -> ArmyData:
	var array = []
	for unit in units:
		array.append(StackData.new(unit, 1))
	return ArmyData.new(array)

func _on_animation_finished():
	$Battle/BattleEvents.emit_signal("resume")
