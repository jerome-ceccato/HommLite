class_name LogHelper
extends Node

export(Color) var player_color: Color
export(Color) var enemy_color: Color


func pluralized_name(unit: UnitData, amount: int):
	return pluralize(amount, unit.display_name, unit.display_name_plural)

func pluralize(count: int, singular: String, plural: String) -> String:
	return singular if count <= 1 else plural

func side_color(content, side: int) -> String:
	var color = player_color if side == BattleStack.Side.LEFT else enemy_color
	return colored(content, color)

func colored(content, color: Color) -> String:
	var color_code = "#" + color.to_html(false)
	return "[color=%s]%s[/color]" % [color_code, content]

# Battle

func entry_representation(entry: BattleLogger.Entry) -> String:
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
		side_color(pluralized_name(entry.source.unit, entry.source.amount), entry.source.side),
		pluralize(entry.source.amount, "waits", "wait"),
	]


func _skip_representation(entry: BattleLogger.Entry) -> String:
	return "The %s %s their turn." % [
		side_color(pluralized_name(entry.source.unit, entry.source.amount), entry.source.side),
		pluralize(entry.source.amount, "skips", "skip"),
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
		side_color(pluralized_name(entry.source.unit, entry.source.amount), entry.source.side),
		pluralize(entry.source.amount, "does", "do"),
		entry.damage,
	]

func _death_text(entry: BattleLogger.Entry) -> String:
	if entry.death > 0:
		return " %s %s %s." % [
			entry.death,
			side_color(pluralized_name(entry.target.unit, entry.death), entry.target.side),
			pluralize(entry.death, "dies", "die"),
		]
	else:
		return ""
