class_name UIEvents
extends Node

signal mouse_moved(state) # CursorState
signal mouse_clicked(state) # CursorState

# general signal to resume logic when the UI is done with changes
signal animation_finished()
