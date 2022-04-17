extends Node2D

onready var map: AdventureMap = $AdventureMap


func _ready():
	for child in [$Selector, $Debug, $Hero]:
		child.map = map
	$Hero.set_position_hex(Vector3.ZERO)
	
	$Selector.connect("adventure_tile_selected", self, "_on_hex_selected")


func _on_hex_selected(hex: Vector3):
	var hexdata: AdventureTile = map.hexmap.get_hex(hex)
	if hexdata and hexdata.revealed and hexdata.get_base_tile_id() == 0:
		$Hero.set_position_hex(hex)
		for direction in range(6):
			map.reveal(map.hexmap.neighbor_hex(hex, direction))
