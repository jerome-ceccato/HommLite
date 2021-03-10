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
	Context.player_army = Army.new([]).deserialize(data["player_army"])
	if data.has("current_world"):
		Context.current_world = CurrentWorld.new(null).deserialize(data["current_world"])
	Context.souls = data["souls"]


func _serialize_context():
	var ctx = {
		"player_army": Context.player_army.serialized(),
		"souls": Context.souls
	}
	if Context.current_world:
		ctx["current_world"] = Context.current_world.serialized()
	return ctx
