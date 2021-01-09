extends RichTextLabel

func _on_Battle_new_combat_log(entry: BattleLogger.Entry):
	if get_total_character_count() > 0:
		text += "\n"
	append_bbcode(_entry_representation(entry))

func _entry_representation(entry: BattleLogger.Entry) -> String:
	var content = "The %s %s %s damage." % [
		_puralized_name(entry.source.stack.unit, entry.source.amount),
		_pluralize(entry.source.amount, "does", "do"),
		entry.damage
	]
	
	if entry.death > 0:
		content += " %s %s %s." % [
			entry.death,
			_puralized_name(entry.target.stack.unit, entry.death),
			_pluralize(entry.death, "dies", "die"),
		]
	return content

func _puralized_name(unit: UnitData, amount: int):
	return _pluralize(amount, unit.display_name, unit.display_name_plural)

func _pluralize(count: int, singular: String, plural: String) -> String:
	return singular if count <= 1 else plural
