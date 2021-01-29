class_name PlayerArmy
extends Reference

static func get_army() -> ArmyData:
	var bee = load("res://assets/data/bee.tres")
	var chicken = load("res://assets/data/chicken.tres")
	var uchicken = load("res://assets/data/uchicken.tres")
	var cow = load("res://assets/data/cow.tres")
	var template = load("res://assets/data/template.tres")
	
	return ArmyData.new([
		StackData.new(cow, 9),
		StackData.new(uchicken, 9),
	])
