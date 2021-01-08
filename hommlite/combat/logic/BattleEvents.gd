class_name BattleEvents
extends Node

# State update
signal game_state_changed(battle) # Battle

# UI feedback for combat loop
signal stack_moved(stack, movement) # BattleStack, BattleMovement
signal stack_damaged(stack) # BattleStack
signal stack_destroyed(stack) # BattleStack

# General signal to resume logic when the UI is done with changes
signal resume()
