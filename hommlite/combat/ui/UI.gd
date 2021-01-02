extends Node

onready var combat_area = $CombatArea
onready var events = $UIEvents

var battle: Battle


func setup(_battle: Battle):
	battle = _battle
	
	combat_area.setup_battle(battle, events)
	$CellLabel.setup($CombatArea/HexGrid)
