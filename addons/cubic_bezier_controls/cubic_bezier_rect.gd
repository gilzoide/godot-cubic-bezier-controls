tool
extends Control
class_name CubicBezierRect
"""
Control to display a CubicBezierCurve.

At most `resolution` points will be calculated and drawn.
"""

export(Color) var line_color = Color.white
export(float) var line_width = 2
export(Resource) var curve setget set_curve, get_curve
export(int) var resolution = 100

var _curve: CubicBezierCurve = null


func _ready() -> void:
	if _curve == null:
		set_curve(null)


func _draw() -> void:
	if _curve == null:
		return
	draw_set_transform(Vector2(0, rect_size.y), 0, Vector2(1, -1))
	var points = PoolVector2Array()
	var point_count = max(rect_size.x, resolution)
	var control1 = _curve.control1
	var control2 = _curve.control2
	points.append(Vector2.ZERO)
	for i in range(1, point_count):
		var t = float(i) / point_count
		var point = CubicBezierCurve.interpolate_control_points(control1, control2, t) * rect_size
		points.append(point)
	points.append(rect_size)
	draw_polyline(points, line_color, line_width)


func set_curve(value: CubicBezierCurve) -> void:
	if _curve == value:
		return
	if _curve and _curve.is_connected("changed", self, "_on_curve_updated"):
		_curve.disconnect("changed", self, "_on_curve_updated")
	if value == null:
		value = CubicBezierCurve.new()
		value.resource_local_to_scene = true
	_curve = value
	if not _curve.is_connected("changed", self, "_on_curve_updated"):
		_curve.connect("changed", self, "_on_curve_updated")
	update()


func get_curve() -> CubicBezierCurve:
	return _curve


func _on_curve_updated() -> void:
	if visible:
		update()
