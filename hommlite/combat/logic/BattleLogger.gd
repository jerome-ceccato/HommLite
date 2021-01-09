class_name BattleLogger
extends Node

var _events: BattleEvents
var _logs := [] # [Entry]


class Entry:
	var type: int
	
	var round_number: int
	var source: BattleStack
	var target: BattleStack
	var damage: int
	var death: int
	
	enum Type {
		ROUND_STARTED, 
		ATTACK,
		SKIP,
		WAIT
	}
	
	func _init(_type: int):
		type = _type


func setup(events: BattleEvents):
	_events = events


func log_attack(source: BattleStack, target: BattleStack, damage: int, death: int):
	var entry = Entry.new(Entry.Type.ATTACK)
	entry.source = source
	entry.target = target
	entry.damage = damage
	entry.death = death
	
	_logs.append(entry)
	_events.emit_signal("new_combat_log", entry)


func log_round_started(n: int):
	var entry = Entry.new(Entry.Type.ROUND_STARTED)
	entry.round_number = n
	
	_logs.append(entry)
	_events.emit_signal("new_combat_log", entry)


func log_skip(source: BattleStack):
	var entry = Entry.new(Entry.Type.SKIP)
	entry.source = source
	
	_logs.append(entry)
	_events.emit_signal("new_combat_log", entry)


func log_wait(source: BattleStack):
	var entry = Entry.new(Entry.Type.WAIT)
	entry.source = source
	
	_logs.append(entry)
	_events.emit_signal("new_combat_log", entry)
