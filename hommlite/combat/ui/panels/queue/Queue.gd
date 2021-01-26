extends Node2D

onready var container: HBoxContainer = $HBoxContainer


func setup(log_helper: LogHelper):
	for item in container.get_children():
		var queue_item = item as QueueItem
		queue_item.setup(log_helper)
		queue_item.update_with_stack(null)


func _on_Battle_game_state_changed(battle: Battle):
	var items = container.get_children()
	var battle_queue: Array = battle.all_stacks() #TODO: actual queue
	for i in range(items.size()):
		var queue_item = items[i] as QueueItem
		var stack = battle_queue[i] if i < battle_queue.size() else null
		queue_item.update_with_stack(stack)
