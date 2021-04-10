tool
extends Resource
class_name CubicBezierCurve
"""
Cubic Bézier curve defined between points P0 = (0, 0) and P3 = (1, 1), using
control points P1 = `control_1` and P2 = `control_2`.
"""

const START = Vector2.ZERO
const END = Vector2.ONE

export(Vector2) var control1 = Vector2.ZERO setget set_control1, get_control1
export(Vector2) var control2 = Vector2.ONE setget set_control2, get_control2

var _control1 := Vector2.ZERO
var _control2 := Vector2.ONE


func _init(control1 := Vector2.ZERO, control2 := Vector2.ONE) -> void:
	_control1 = control1
	_control2 = control2


func copy_from(other: CubicBezierCurve) -> void:
	_control1 = other._control1
	_control2 = other._control2
	emit_signal("changed")


func set_control1(value: Vector2) -> void:
	_control1 = value
	emit_signal("changed")


func get_control1() -> Vector2:
	return _control1


func set_control2(value: Vector2) -> void:
	_control2 = value
	emit_signal("changed")


func get_control2() -> Vector2:
	return _control2


func interpolate(t: float) -> Vector2:
	return interpolate_control_points(_control1, _control2, t)


func get_curve2D() -> Curve2D:
	var curve2D = Curve2D.new()
	fill_curve2D(curve2D)
	return curve2D


func fill_curve2D(curve2D: Curve2D) -> void:
	curve2D.clear_points()
	curve2D.add_point(START, Vector2.ZERO, control1)
	curve2D.add_point(END, control2 - END, Vector2.ZERO)


static func interpolate_control_points(control1: Vector2, control2: Vector2, t: float) -> Vector2:
	return interpolate_points(START, control1, control2, END, t)


# Ref: https://github.com/godotengine/godot/blob/e8f73124a7d97abc94cea3cf7fe5b5614f61a448/scene/resources/curve.cpp#L36-L45
static func interpolate_points(start: Vector2, control1: Vector2, control2: Vector2, end: Vector2, t: float) -> Vector2:
	var omt = (1.0 - t)
	var omt2 = omt * omt
	var omt3 = omt2 * omt
	var t2 = t * t
	var t3 = t2 * t
	return start * omt3 \
			+ control1 * omt2 * t * 3.0 \
			+ control2 * omt * t2 * 3.0 \
			+ end * t3
