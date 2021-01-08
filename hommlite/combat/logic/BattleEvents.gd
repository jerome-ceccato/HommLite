class_name BattleEvents
extends Node

# UI feedback for combat loop
signal active_stack_changed(stack) # BattleStack
signal stack_moved(stack, movement) # BattleStack, BattleMovement
signal stack_damaged(stack) # BattleStack
signal stack_destroyed(stack) # BattleStack

# End game
signal game_ended(winner) # Side

# general signal to resume logic when the UI is done with changes
signal resume()
