class_name BattleEvents
extends Node

# State update
signal game_state_changed(battle) # Battle

# UI feedback for combat loop
signal stack_moved(stack, movement) # BattleStack, BattleMovement
signal stack_attacked(source, target, retaliation) # BattleStack, BattleStack, bool

# Logs
signal new_combat_log(entry) # BattleLogger.Entry

# General signal to resume logic when the UI is done with changes
signal resume()
