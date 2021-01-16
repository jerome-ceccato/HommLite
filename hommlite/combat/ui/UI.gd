extends Node

onready var events = $UIEvents

var battle: Battle


func setup(_battle: Battle):
	battle = _battle
	
	$CombatArea.setup_battle(battle, events)
	$Cursor.setup(battle, $CombatArea/HexGrid)
	$BottomPanel.setup(events)
