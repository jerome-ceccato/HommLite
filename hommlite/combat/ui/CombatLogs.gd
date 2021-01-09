extends RichTextLabel

export(Color) var death_color: Color

func _on_Battle_new_combat_log(entry: BattleLogger.Entry):
	append_bbcode(_entry_representation(entry))


func _entry_representation(entry: BattleLogger.Entry) -> String:
	return "%s%s%s" % [
		"\n" if get_total_character_count() > 0 else "",
		_damage_text(entry),
		_death_text(entry)
	]

func _damage_text(entry: BattleLogger.Entry) -> String:
	return "The %s %s %s damage." % [
		_puralized_name(entry.source.stack.unit, entry.source.amount),
		_pluralize(entry.source.amount, "does", "do"),
		entry.damage,
	]

func _death_text(entry: BattleLogger.Entry) -> String:
	if entry.death > 0:
		return " %s %s %s." % [
			_colored(entry.death, death_color),
			_puralized_name(entry.target.stack.unit, entry.death),
			_pluralize(entry.death, "dies", "die"),
		]
	else:
		return ""


func _puralized_name(unit: UnitData, amount: int):
	return _pluralize(amount, unit.display_name, unit.display_name_plural)

func _pluralize(count: int, singular: String, plural: String) -> String:
	return singular if count <= 1 else plural

func _colored(content, color: Color) -> String:
	var color_code = "#" + color.to_html(false)
	return "[color=%s]%s[/color]" % [color_code, content]
