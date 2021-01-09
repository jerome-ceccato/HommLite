class_name BattleLogger
extends Node

var _events: BattleEvents
var _logs := [] # [Entry]


class Entry:
	var source: BattleStack
	var target: BattleStack
	var damage: int
	var death: int


func setup(events: BattleEvents):
	_events = events


func log_attack(source: BattleStack, target: BattleStack, damage: int, death: int):
	var entry = Entry.new()
	entry.source = source
	entry.target = target
	entry.damage = damage
	entry.death = death
	
	_logs.append(entry)
	_events.emit_signal("new_combat_log", entry)
