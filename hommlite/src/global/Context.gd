extends Node

var current_battle: BattleSetup

var save_data := SaveData.new()


func _ready():
	load_save()


func load_battle(target: Army):
	current_battle = BattleLoader.load_battle(save_data.hero.army, target)

func finish_battle(victory: bool):
	if victory:
		save_data.resources.gold += 1
	else:
		save_data.resources.gold = 0
		save_data.hero.reset_army() 
	save()


func has_save():
	return Persistence.has_save()

func load_save():
	save_data = Persistence.load_saved_context()

func save():
	Persistence.save_context(save_data)

func delete_save():
	Persistence.delete_save()
