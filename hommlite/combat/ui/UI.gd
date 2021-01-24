extends Node

onready var events = $UIEvents
onready var log_helper = $LogHelper

var battle: Battle


func setup(_battle: Battle, map: MapData):
	battle = _battle
	
	$Background.texture = load(map.bg_texture_path)
	$CombatArea.setup_battle(battle, events)
	$Cursor.setup(battle, $CombatArea/HexGrid)
	$BottomPanel.setup(events)
	$BottomPanel/CombatLogs.setup(log_helper)
	$BottomPanel/CurrentActionLabel.setup(battle, log_helper)
	$LeftPanel.setup(events)
