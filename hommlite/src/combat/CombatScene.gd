tool
extends Node2D

onready var battle: Battle = $Battle
onready var ui = $UI

onready var battle_events: BattleEvents = $Battle/BattleEvents
onready var ui_events: UIEvents = $UI/UIEvents

var _scene_navigation: GameSceneNavigation setget inject_scene_navigation
func inject_scene_navigation(nav):
	_scene_navigation = nav
	$UI/Dialogs/EndScreen.scene_navigation = nav


func _ready():
	if Engine.editor_hint:
		_editor_specific_features()
		return
	
	var data = Context.current_world.current_battle
	battle.setup_battle(data)
	ui.setup(battle, data.map)
	
	_setup_bindings()
	_run()


func _setup_bindings():
	for listener in [
		$UI/CombatArea/Grid/ActionGridHover,
		$UI/CombatArea/Grid/PathfindingOverlay,
		$UI/CombatArea/Grid/UnitHoverMovementOverlay,
		$UI/Cursor,
		$UI/BottomPanel/CurrentActionLabel,
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
		$UI/BottomPanel/CurrentActionLabel,
		$UI/BottomPanel/Queue,
		$UI/LeftPanel,
		]:
		battle_events.connect("game_state_changed", listener, "_on_Battle_game_state_changed")
	
	for listener in [$UI/TopPanel/CombatLogs]:
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
