extends EditorProperty

const PROPERTY_NAMES = PoolStringArray(["control1", "control2"])

var _edit_control = CubicBezierEdit.new()


func _ready() -> void:
	add_child(_edit_control)
	set_bottom_editor(_edit_control)
	rect_min_size = Vector2(64, 128)
	_edit_control.rect_clip_content = true
	_edit_control.rect_min_size = rect_min_size
	_edit_control.connect("control1_changed", self, "_on_control1_changed")
	_edit_control.connect("control2_changed", self, "_on_control2_changed")


func update_property() -> void:
	_edit_control.curve = get_edited_object()
	_edit_control.update()


func _on_control1_changed():
	emit_changed("control1", _edit_control.curve.control1)


func _on_control2_changed():
	emit_changed("control2", _edit_control.curve.control2)
