tool
extends Node2D

onready var battle: Battle = $Battle
onready var ui = $UI

onready var battle_events: BattleEvents = $Battle/BattleEvents
onready var ui_events: UIEvents = $UI/UIEvents

func _ready():
	if Engine.editor_hint:
		_editor_specific_features()
		return
	
	var setup_data = BattleSetup.new(_make_armies(), _make_obstacles())
	
	battle.setup_battle(setup_data)
	ui.setup(battle)
	
	_setup_bindings()
	_run()


func _make_armies() -> Array:
	var bee = load("res://assets/data/bee.tres")
	var chicken = load("res://assets/data/chicken.tres")
	var uchicken = load("res://assets/data/uchicken.tres")
	var bbee = load("res://assets/data/bigbee.tres")
	var template = load("res://assets/data/template.tres")
	
	var left_army = ArmyData.new([
		StackData.new(template, 1),
		StackData.new(bee, 26),
		StackData.new(uchicken, 68),
	])
	
	var right_army = ArmyData.new([
		StackData.new(chicken, 1),
		StackData.new(bbee, 5),
		StackData.new(chicken, 165),
	])
	
	return [left_army, right_army]


func _make_obstacles() -> Array:
	var rock_reference = "res://assets/combat/rock.png"
	return [
		ObstacleData.new(BattleCoords.new(3, 5), rock_reference),
		ObstacleData.new(BattleCoords.new(4, 4), rock_reference),
		ObstacleData.new(BattleCoords.new(5, 4), rock_reference),
		ObstacleData.new(BattleCoords.new(5, 3), rock_reference),
		ObstacleData.new(BattleCoords.new(6, 3), rock_reference),
		ObstacleData.new(BattleCoords.new(7, 3), rock_reference),
		ObstacleData.new(BattleCoords.new(8, 4), rock_reference),
		ObstacleData.new(BattleCoords.new(8, 5), rock_reference),
	]


func _setup_bindings():
	for listener in [
		$UI/CombatArea/Grid/ActionGridHover,
		$UI/CombatArea/Grid/PathfindingOverlay,
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
		$Battle/AIController,
		$UI/Dialogs/EndScreen,
		$UI/Cursor,
		$UI/CombatArea/Grid,
		$UI/CombatArea/VisibleUnits,
		$UI/CombatArea/Grid/ActionGridHover,
		$UI/CombatArea/Grid/ActiveStackMovementOverlay,
		$UI/CombatArea/Grid/PathfindingOverlay,
		]:
		battle_events.connect("game_state_changed", listener, "_on_Battle_game_state_changed")
	
	for listener in [$UI/BottomPanel/CombatLogs]:
		battle_events.connect("new_combat_log", listener, "_on_Battle_new_combat_log")
	
	ui_events.connect("animation_finished", self, "_on_animation_finished")


func _run():
	battle.run()


func _on_animation_finished():
	battle_events.emit_signal("resume")


func _editor_specific_features():
	var hexgrid = get_node("UI/CombatArea/HexGrid")
	hexgrid.setup(get_node("Battle/BattleGrid"))
	get_node("UI/CombatArea/Grid/GridBackground").setup(hexgrid)
	get_node("UI/CombatArea/Grid/GridBackground").update()
	get_node("UI/CombatArea/Grid/GridCoords").setup(hexgrid)
	get_node("UI/CombatArea/Grid/GridCoords").update()
	get_node("UI/CombatArea")._center_self()
