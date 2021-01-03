extends Node

onready var combat_area = $CombatArea
onready var cursor = $Cursor
onready var events = $UIEvents

var battle: Battle


func setup(_battle: Battle):
	battle = _battle
	
	combat_area.setup_battle(battle, events)
	cursor.setup(battle)
	
	$CellLabel.setup($CombatArea/HexGrid)
