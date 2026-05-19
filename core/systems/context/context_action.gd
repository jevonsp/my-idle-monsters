class_name ContextAction
extends RefCounted

var id: String
var label: String
var enabled := true


func _init(
		_id: String,
		_label: String,
		_enabled := true,
) -> void:
	id = _id
	label = _label
	enabled = _enabled
