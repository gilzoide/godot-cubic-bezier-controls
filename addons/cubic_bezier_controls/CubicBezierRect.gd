tool
extends Control

export(Color) var line_color = Color.white
export(float) var line_width = 2
export(Resource) var curve setget set_curve, get_curve
export(int) var resolution = 100

var _curve: CubicBezierCurve


func _ready() -> void:
	if _curve == null:
		set_curve(CubicBezierCurve.new())


func _draw() -> void:
	if _curve == null:
		return
	draw_set_transform(Vector2(0, rect_size.y), 0, Vector2(1, -1))
	var points = PoolVector2Array()
	var max_points = min(resolution, rect_size.x)
	for i in max_points:
		var t = float(i) / max_points
		var point = _curve.interpolate(t) * rect_size
		points.append(point)
	draw_polyline(points, line_color, line_width)


func set_curve(value: CubicBezierCurve) -> void:
	if _curve and _curve.is_connected("changed", self, "_on_curve_updated"):
		_curve.disconnect("changed", self, "_on_curve_updated")
	_curve = value
	_curve.connect("changed", self, "_on_curve_updated")


func get_curve() -> CubicBezierCurve:
	return _curve


func _on_curve_updated() -> void:
	if visible:
		update()
