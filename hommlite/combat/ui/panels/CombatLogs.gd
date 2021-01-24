extends RichTextLabel

var _log_helper: LogHelper

func setup(log_helper: LogHelper):
	_log_helper = log_helper


func _on_Battle_new_combat_log(entry: BattleLogger.Entry):
	var content = _entry_representation(entry)
	if content:
		if get_total_character_count() > 0:
			content = "\n" + content
		append_bbcode(content)


func _entry_representation(entry: BattleLogger.Entry) -> String:
	match entry.type:
		BattleLogger.Entry.Type.ROUND_STARTED:
			return _round_representation(entry)
		BattleLogger.Entry.Type.ATTACK:
			return _attack_representation(entry)
		BattleLogger.Entry.Type.WAIT:
			return _wait_representation(entry)
		BattleLogger.Entry.Type.SKIP:
			return _skip_representation(entry)
		BattleLogger.Entry.Type.GAME_ENDED:
			return _game_ended_representation(entry)
		_:
			return ""


func _game_ended_representation(entry: BattleLogger.Entry) -> String:
	return "The combat has ended. %s." % [
		"You won" if entry.winner == BattleStack.Side.LEFT else "You lost"
	]


func _wait_representation(entry: BattleLogger.Entry) -> String:
	return "The %s %s." % [
		_log_helper.side_color(_log_helper.pluralized_name(entry.source.stack.unit, entry.source.amount), entry.source.side),
		_log_helper.pluralize(entry.source.amount, "waits", "wait"),
	]


func _skip_representation(entry: BattleLogger.Entry) -> String:
	return "The %s %s their turn." % [
		_log_helper.side_color(_log_helper.pluralized_name(entry.source.stack.unit, entry.source.amount), entry.source.side),
		_log_helper.pluralize(entry.source.amount, "skips", "skip"),
	]


func _round_representation(entry: BattleLogger.Entry) -> String:
	return "Round %s begins." % entry.round_number


func _attack_representation(entry: BattleLogger.Entry) -> String:
	return "%s%s" % [
		_damage_text(entry),
		_death_text(entry),
	]

func _damage_text(entry: BattleLogger.Entry) -> String:
	return "The %s %s %s damage." % [
		_log_helper.side_color(_log_helper.pluralized_name(entry.source.stack.unit, entry.source.amount), entry.source.side),
		_log_helper.pluralize(entry.source.amount, "does", "do"),
		entry.damage,
	]

func _death_text(entry: BattleLogger.Entry) -> String:
	if entry.death > 0:
		return " %s %s %s." % [
			entry.death,
			_log_helper.side_color(_log_helper.pluralized_name(entry.target.stack.unit, entry.death), entry.target.side),
			_log_helper.pluralize(entry.death, "dies", "die"),
		]
	else:
		return ""
