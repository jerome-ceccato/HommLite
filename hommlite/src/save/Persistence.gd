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


func delete_save():
	var dir = Directory.new()
	dir.remove(SAVE_PATH)


func _deserialize_context(data: Dictionary):
	Context.selected_battle = data["selected_battle"]
	Context.battle_progress = data["battle_progress"]
	Context.player_army = Army.new([]).deserialize(data["player_army"])
	Context.currency = data["currency"]


func _serialize_context():
	return {
		"player_army": Context.player_army.serialized(),
		"selected_battle": Context.selected_battle,
		"battle_progress": Context.battle_progress,
		"currency": Context.currency,
	}
