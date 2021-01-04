class_name BattleEvents
extends Node

signal active_stack_changed(stack) # BattleStack
signal stack_moved(stack, previous_position) # BattleStack, BattleCoords
signal stack_damaged(stack) # BattleStack
signal stack_destroyed(stack) # BattleStack
