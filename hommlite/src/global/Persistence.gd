class_name Persistence
extends RefCounted

const SAVE_PATH := "user://player.save"

static func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


static func load_saved_context() -> SaveData:
	if not FileAccess.file_exists(SAVE_PATH):
		return SaveData.new()

	var save_game = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(save_game.get_as_text())
	var data = test_json_conv.get_data()
	var ret = SaveData.new().deserialize(data)
	return ret


static func save_context(data: SaveData):
	var save_game = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	save_game.store_string(JSON.new().stringify(data.serialized()))


static func delete_save():
	DirAccess.open("user://").remove("player.save")

