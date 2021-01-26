extends Node2D

onready var container: HBoxContainer = $HBoxContainer


func setup(log_helper: LogHelper):
	for item in container.get_children():
		var queue_item = item as QueueItem
		queue_item.setup(log_helper)
		queue_item.update_with_stack(null)


func _on_Battle_game_state_changed(battle: Battle):
	var items = container.get_children()
	var battle_queue_rounds: Array = battle.get_queue_prediction(items.size())
	
	var progress = 0
	for battle_round in battle_queue_rounds:
		if progress > 0:
			# Round number
			var queue_item = items[progress] as QueueItem
			queue_item.update_with_stack(null)
			progress += 1
		for stack in battle_round:
			var queue_item = items[progress] as QueueItem
			queue_item.update_with_stack(stack)
			progress += 1
