extends RichTextLabel

export(Color) var left_color: Color
export(Color) var right_color: Color

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
		_side_color(_puralized_name(entry.source.stack.unit, entry.source.amount), entry.source.side),
		_pluralize(entry.source.amount, "waits", "wait"),
	]


func _skip_representation(entry: BattleLogger.Entry) -> String:
	return "The %s %s their turn." % [
		_side_color(_puralized_name(entry.source.stack.unit, entry.source.amount), entry.source.side),
		_pluralize(entry.source.amount, "skips", "skip"),
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
		_side_color(_puralized_name(entry.source.stack.unit, entry.source.amount), entry.source.side),
		_pluralize(entry.source.amount, "does", "do"),
		entry.damage,
	]

func _death_text(entry: BattleLogger.Entry) -> String:
	if entry.death > 0:
		return " %s %s %s." % [
			entry.death,
			_side_color(_puralized_name(entry.target.stack.unit, entry.death), entry.target.side),
			_pluralize(entry.death, "dies", "die"),
		]
	else:
		return ""


func _puralized_name(unit: UnitData, amount: int):
	return _pluralize(amount, unit.display_name, unit.display_name_plural)

func _pluralize(count: int, singular: String, plural: String) -> String:
	return singular if count <= 1 else plural

func _side_color(content, side: int) -> String:
	var color = left_color if side == BattleStack.Side.LEFT else right_color
	return _colored(content, color)

func _colored(content, color: Color) -> String:
	var color_code = "#" + color.to_html(false)
	return "[color=%s]%s[/color]" % [color_code, content]
