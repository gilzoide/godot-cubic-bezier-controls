extends EditorInspectorPlugin

const CubicBezierCurveEditorProperty = preload("res://addons/cubic_bezier_controls/cubic_bezier_curve_editor_property.gd")


func can_handle(object: Object) -> bool:
	return object is CubicBezierCurve


func parse_begin(object: Object) -> void:
	var editor_property = CubicBezierCurveEditorProperty.new()
	add_property_editor_for_multiple_properties("Curve", CubicBezierCurveEditorProperty.PROPERTY_NAMES, editor_property)
