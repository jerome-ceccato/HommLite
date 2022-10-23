extends Resource
class_name UnitData

# Represents the immutable attributes of a unit

@export var id: String
@export var display_name: String
@export var display_name_plural: String

@export var large: bool = false

@export_range(0, 30) var speed: int = 1
@export_range(0, 100) var initiative: int = 1
@export var flying: bool = false

@export_range(0, 100) var dmg_low: int = 1
@export_range(0, 100) var dmg_high: int = 1
@export var ranged: bool = false

@export_range(0, 1000) var hp: int = 1
@export_range(0, 100) var def: int = 1
@export_range(0, 100) var atk: int = 1
