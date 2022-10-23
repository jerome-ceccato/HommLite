extends RichTextLabel

var _log_helper: LogHelper

func setup(log_helper: LogHelper):
	_log_helper = log_helper


func _on_Battle_new_combat_log(entry: BattleLogger.Entry):
	if _is_entry_allowed(entry):
		var content = _log_helper.entry_representation(entry)
		if content:
			content = _apply_style(content)
			if get_total_character_count() > 0:
				content = "\n" + content
			append_text(content)


func _is_entry_allowed(entry: BattleLogger.Entry) -> bool:
	return entry.type != BattleLogger.Entry.Type.GAME_ENDED

func _apply_style(content: String) -> String:
	return "[center]%s[/center]" % [content]
