class_name PlayerInvCanvasLayer
extends CanvasLayer

enum Layout { MAIN, STORE }

var layouts: Dictionary = {
	Layout.MAIN: {
		"preset": Control.LayoutPreset.PRESET_CENTER_TOP,
		"margin": 0,
		"visible": true,
	},
	Layout.STORE: {
		"preset": Control.LayoutPreset.PRESET_CENTER_LEFT,
		"margin": 300,
		"visible": true,
	},
}


func connect_signals() -> void:
	if not EventBus.request_layout.is_connected(_on_request_layout):
		EventBus.request_layout.connect(_on_request_layout)


func _on_request_layout(layout_type: Layout) -> void:
	var entry: Dictionary = layouts.get(layout_type, { })
	if entry.is_empty():
		return
	_move_node_offsets(
		Global.game.player_inv,
		entry.get("preset"),
		entry.get("margin", 0),
		entry.get("visible", true),
	)


func _move_node_offsets(node: Node, preset: Control.LayoutPreset, margin: int = 0, _visible: bool = true) -> void:
	if node == null:
		return
	node.set_anchors_and_offsets_preset(
		preset,
		Control.PRESET_MODE_MINSIZE,
		margin,
	)
	node.visible = _visible
