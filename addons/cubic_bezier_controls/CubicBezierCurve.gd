class_name CubicBezierCurve

extends Resource
"""
Cubic Bézier curve defined between points P0 = (0, 0) and P3 = (1, 1), using
control points P1 = `control_1` and P2 = `control_2`.
"""

const START = Vector2.ZERO
const END = Vector2.ONE

export(Vector2) var control_1 = Vector2.ZERO setget set_control_1, get_control_1
export(Vector2) var control_2 = Vector2.ONE setget set_control_2, get_control_2

var _control_1 := Vector2.ZERO
var _control_2 := Vector2.ONE


func _init(control_1 := Vector2.ZERO, control_2 := Vector2.ONE) -> void:
	_control_1 = control_1
	_control_2 = control_2


func set_control_1(value: Vector2) -> void:
	_control_1 = value
	emit_changed()


func get_control_1() -> Vector2:
	return _control_1


func set_control_2(value: Vector2) -> void:
	_control_2 = value
	emit_changed()


func get_control_2() -> Vector2:
	return _control_2


func interpolate(t: float) -> float:
	return bezier_interpolate(START, _control_1, _control_2, END, t)


func get_curve2D() -> Curve2D:
	var curve2D = Curve2D.new()
	fill_curve2D(curve2D)
	return curve2D


func fill_curve2D(curve2D: Curve2D) -> void:
	curve2D.clear_points()
	curve2D.add_point(START, Vector2.ZERO, control_1)
	curve2D.add_point(END, control_2 - END, Vector2.ZERO)


# Ref: https://github.com/godotengine/godot/blob/e8f73124a7d97abc94cea3cf7fe5b5614f61a448/scene/resources/curve.cpp#L36-L45
static func bezier_interpolate(start: Vector2, control_1: Vector2, control_2: Vector2, end: Vector2, t: float) -> float:
	var omt = (1.0 - t)
	var omt2 = omt * omt
	var omt3 = omt2 * omt
	var t2 = t * t
	var t3 = t2 * t;
	return start * omt3 \
			+ control_1 * omt2 * t * 3.0 \
			+ control_2 * omt * t2 * 3.0 \
			+ end * t3
