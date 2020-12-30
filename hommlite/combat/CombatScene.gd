extends Node2D

onready var grid := $Grid
onready var ui := $UI

var left_army: Army
var right_army: Army

func _ready():
	var gob_sprite = load("res://assets/combat/gob.png")
	var skelly_sprite = load("res://assets/combat/skeleton.png")
	
	left_army = create_army(gob_sprite, 7)
	right_army = create_army(skelly_sprite, 7)
	
	grid.setup_battle(left_army, right_army)
	setup_ui()

func setup_ui():
	grid.connect("hex_grid_hovered", ui, "_on_Grid_hex_grid_hovered")

func create_army(texture: Texture, units: int) -> Army:
	var array = []
	for i in units:
		array.append(UnitStack.new(Unit.new(texture), 1))
	return Army.new(array)
