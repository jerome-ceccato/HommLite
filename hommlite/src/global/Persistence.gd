class_name Persistence
extends Reference

const SAVE_PATH := "user://player.save"

static func has_save() -> bool:
	return File.new().file_exists(SAVE_PATH)


static func load_saved_context() -> SaveData:
	var save_game = File.new()
	if not save_game.file_exists(SAVE_PATH):
		return SaveData.new()

	save_game.open(SAVE_PATH, File.READ)
	var data = parse_json(save_game.get_as_text())
	var ret = SaveData.new().deserialize(data)
	save_game.close()
	return ret


static func save_context(data: SaveData):
	var save_game = File.new()
	
	save_game.open(SAVE_PATH, File.WRITE)
	save_game.store_string(to_json(data.serialized()))
	save_game.close()


static func delete_save():
	var dir = Directory.new()
	dir.remove(SAVE_PATH)

