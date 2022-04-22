extends Resource
class_name UnitData

# Represents the immutable attributes of a unit

export(String) var id: String
export(String) var display_name: String
export(String) var display_name_plural: String

export(bool) var large: bool = false

export(int, 30) var speed: int = 1
export(int, 100) var initiative: int = 1
export(bool) var flying: bool = false

export(int, 100) var dmg_low: int = 1
export(int, 100) var dmg_high: int = 1
export(bool) var ranged: bool = false

export(int, 1, 1000) var hp: int = 1
export(int, 1, 100) var def: int = 1
export(int, 1, 100) var atk: int = 1
