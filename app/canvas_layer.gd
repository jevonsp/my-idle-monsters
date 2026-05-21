extends CanvasLayer

@onready var player_inv: InvGrid = $PlayerInv
@onready var player_hot_bar: InvHotbar = $PlayerHotBar


func connect_signals() -> void:
	if not EventBus.request_layout.is_connected(_move_node_offsets):
		EventBus.request_layout.connect(_move_node_offsets)


func _move_node_offsets(node: Node, preset: Control.LayoutPreset, margin: int = 0, _visible: bool = true) -> void:
	node.set_anchors_and_offsets_preset(
		preset,
		Control.PRESET_MODE_MINSIZE,
		margin,
	)
	node.visible = _visible
