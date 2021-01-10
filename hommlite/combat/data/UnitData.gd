class_name UnitData
extends Resource

# Represents a unit type

export(String) var id: String
export(String) var display_name: String
export(String) var display_name_plural: String

export(int, 30) var speed: int = 1
export(int, 100) var initiative: int = 1
export(bool) var flying: bool = false

export(int, 100) var attack_low: int = 1
export(int, 100) var attack_high: int = 1
export(int, 1, 1000) var hp: int = 1
