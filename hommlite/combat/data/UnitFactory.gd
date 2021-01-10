class_name UnitFactory

static func chicken() -> UnitData:
	return UnitData.new("chicken", "chicken", "chickens", 5, 5, false, 1, 1, 1)

static func uchicken() -> UnitData:
	return UnitData.new("uchicken", "blue chicken", "blue chickens", 15, 8, false, 5, 5, 5)

static func bee() -> UnitData:
	return UnitData.new("bee", "bee", "bees", 7, 7, true, 3, 4, 15)
