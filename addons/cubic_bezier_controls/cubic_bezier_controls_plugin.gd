tool
extends EditorPlugin

const CURVE_TYPE_NAME = "CubicBezierCurve"
const RECT_TYPE_NAME = "CubicBezierRect"
const EDIT_TYPE_NAME = "CubicBezierEdit"

var _curve_inspector_plugin


func _enter_tree() -> void:
	var curve_script: Script = load("res://addons/cubic_bezier_controls/cubic_bezier_curve.gd")
	add_custom_type(CURVE_TYPE_NAME, curve_script.get_instance_base_type(), curve_script, null)
	var rect_script: Script = load("res://addons/cubic_bezier_controls/cubic_bezier_rect.gd")
	add_custom_type(RECT_TYPE_NAME, rect_script.get_instance_base_type(), rect_script, null)
	var edit_script: Script = load("res://addons/cubic_bezier_controls/cubic_bezier_edit.gd")
	add_custom_type(EDIT_TYPE_NAME, edit_script.get_instance_base_type(), edit_script, null)
	_curve_inspector_plugin = load("res://addons/cubic_bezier_controls/cubic_bezier_curve_inspector.gd").new()
	add_inspector_plugin(_curve_inspector_plugin)


func _exit_tree() -> void:
	remove_inspector_plugin(_curve_inspector_plugin)
	remove_custom_type(EDIT_TYPE_NAME)
	remove_custom_type(RECT_TYPE_NAME)
	remove_custom_type(CURVE_TYPE_NAME)
