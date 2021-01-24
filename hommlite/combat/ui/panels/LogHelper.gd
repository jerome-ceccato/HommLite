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
