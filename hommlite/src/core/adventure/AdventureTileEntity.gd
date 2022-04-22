extends Reference
class_name AdventureTileEntity

# A serializable wrapper for an entity and its metadata

enum Type {
	BUILDING,
	ENEMY,
}

var _type: int
var _data # AdventureTileBuilding | AdventureTileEnemy

func _init(type: int, data):
	_type = type
	_data = data


func get_tile_id() -> int:
	return _data.get_tile_id()

func get_type() -> int:
	return _type

func get_data():
	return _data


func serialized() -> Dictionary:
	match _type:
		Type.BUILDING:
			return { "type": _type }
		Type.ENEMY:
			return {
				"type": _type,
				"data": _data.serialized()
			}
	return {}

func deserialize(data: Dictionary) -> AdventureTileEntity:
	_type = int(data["type"])
	match _type:
		Type.BUILDING:
			_data = AdventureTileBuilding.new()
		Type.ENEMY:
			_data = AdventureTileEnemy.new(0, Army.new({})).deserialize(data["data"])
	return self

