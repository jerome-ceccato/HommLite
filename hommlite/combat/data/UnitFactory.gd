class_name UnitFactory

static func chicken() -> UnitData:
	return UnitData.new("chicken", 3, 3, false, 1, 1, 1)

static func bee() -> UnitData:
	return UnitData.new("bee", 7, 7, true, 3, 4, 15)
