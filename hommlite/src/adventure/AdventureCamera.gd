extends Camera2D

const ZOOM_OFFSET = Vector2(0.1, 0.1)
const ZOOM_MIN = Vector2(0.2, 0.2)
const ZOOM_MAX = Vector2(2, 2)

var _drag_original_pos
var _mouse_start_pos
var _dragging = false

func _apply_zoom(new_zoom: Vector2):
	if new_zoom.x < ZOOM_MIN.x or new_zoom.y < ZOOM_MIN.y:
		zoom = ZOOM_MIN
	elif new_zoom.x > ZOOM_MAX.x or new_zoom.y > ZOOM_MAX.y:
		zoom = ZOOM_MAX
	else:
		zoom = new_zoom

func _input(event):
	if event.is_action_pressed("adventure_zoom_in"):
		_apply_zoom(zoom - ZOOM_OFFSET)
	elif event.is_action_pressed("adventure_zoom_out"):
		_apply_zoom(zoom + ZOOM_OFFSET)
	elif event.is_action("adventure_drag"):
		if event.is_pressed():
			_mouse_start_pos = event.position
			_drag_original_pos = position
			_dragging = true
		else:
			_dragging = false
	elif event is InputEventMouseMotion and _dragging:
		position = zoom * (_mouse_start_pos - event.position) + _drag_original_pos
