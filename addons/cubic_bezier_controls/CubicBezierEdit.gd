tool
extends "res://addons/cubic_bezier_controls/CubicBezierRect.gd"

enum Dragging {
	NONE,
	HANDLE_1,
	HANDLE_2,
}

export(Color) var handle1_color = Color("#ff0088")
export(Color) var handle2_color = Color("#00aabb")
export(Color) var handle_select_color = Color.yellow
export(float) var handle_radius = 10
export(Color) var handle_line_color = Color.white
export(float) var handle_line_width = 2
export(bool) var clamp_x = true
export(bool) var clamp_y = true

var _dragging = Dragging.NONE


func _draw() -> void:
	._draw()
	# NOTE: transformation for Y+ up is still applied
	
	var handle1_pos = _curve.control_1 * rect_size
	var handle2_pos = _curve.control_2 * rect_size
	draw_line(Vector2.ZERO, handle1_pos, handle_line_color, handle_line_width)
	draw_line(rect_size, handle2_pos, handle_line_color, handle_line_width)
	if _dragging == Dragging.HANDLE_1:
		draw_circle(handle1_pos, handle_radius + 2, handle_select_color)
	draw_circle(handle1_pos, handle_radius, handle1_color)
	if _dragging == Dragging.HANDLE_2:
		draw_circle(handle2_pos, handle_radius + 2, handle_select_color)
	draw_circle(handle2_pos, handle_radius, handle2_color)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			_dragging = _get_dragging_from_position(event.position)
			update()
		elif _dragging != Dragging.NONE:
			update()
			_dragging = Dragging.NONE
	elif event is InputEventMouseMotion:
		if _dragging == Dragging.HANDLE_1:
			var pos = event.position / rect_size
			set_control_point1(Vector2(pos.x, 1 - pos.y))
		elif _dragging == Dragging.HANDLE_2:
			var pos = event.position / rect_size
			set_control_point2(Vector2(pos.x, 1 - pos.y))


func set_control_point1(point: Vector2) -> void:
	if clamp_x:
		point.x = clamp(point.x, 0, 1)
	if clamp_y:
		point.y = clamp(point.y, 0, 1)
	_curve.control_1 = point
	update()


func set_control_point2(point: Vector2) -> void:
	if clamp_x:
		point.x = clamp(point.x, 0, 1)
	if clamp_y:
		point.y = clamp(point.y, 0, 1)
	_curve.control_2 = point
	update()


func _get_dragging_from_position(position: Vector2) -> int:
	if Geometry.is_point_in_circle(position, Vector2(_curve.control_1.x, 1 - _curve.control_1.y) * rect_size, handle_radius):
		return Dragging.HANDLE_1
	elif Geometry.is_point_in_circle(position, Vector2(_curve.control_2.x, 1 - _curve.control_2.y) * rect_size, handle_radius):
		return Dragging.HANDLE_2
	else:
		return Dragging.NONE
