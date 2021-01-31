class_name Persistence
extends Reference

const SAVE_PATH := "user://player.save"

func has_save() -> bool:
	return File.new().file_exists(SAVE_PATH)


func load_saved_context():
	var save_game = File.new()
	if not save_game.file_exists(SAVE_PATH):
		return

	save_game.open(SAVE_PATH, File.READ)
	var data = parse_json(save_game.get_as_text())
	_deserialize_context(data)
	save_game.close()


func save_current_context():
	var save_game = File.new()
	
	save_game.open(SAVE_PATH, File.WRITE)
	save_game.store_string(to_json(_serialize_context()))
	save_game.close()


func _deserialize_context(data: Dictionary):
	Context.battle_progress = data["battle_progress"]
	Context.player_army = Army.new([]).deserialize(data["player_army"])


func _serialize_context():
	return {
		"player_army": Context.player_army.serialized(),
		"battle_progress": Context.battle_progress,
	}
