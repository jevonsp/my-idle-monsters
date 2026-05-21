class_name ScreenManager
extends RefCounted

var _layer_dict: Dictionary[int, Node] = { }
var _next_layer: int = 0


func _init() -> void:
	_connect_signals()


func _connect_signals() -> void:
	if not EventBus.screen_manager_toggle.is_connected(_on_screen_manager_toggle):
		EventBus.screen_manager_toggle.connect(_on_screen_manager_toggle)


func _on_screen_manager_toggle(node: Node, val: bool) -> void:
	if not node:
		return
	if not val:
		_close(node)
		return
	_open(node)


func _open(node: Node) -> void:
	_register(node)
	_set_layer(node)
	_toggle_visibility(node, true)
	_toggle_processing(node, true)
	var prev := _get_previous_layer()
	if prev:
		_toggle_visibility(prev, false)
		_toggle_processing(prev, false)
	_next_layer += 1


func _register(node: Node) -> void:
	_layer_dict[_next_layer] = node


func _toggle_visibility(node: Node, val: bool) -> void:
	if node is Node2D:
		(node as Node2D).visible = val
	elif node is Control:
		(node as Control).visible = val


func _toggle_processing(node: Node, val: bool) -> void:
	if node is Scene:
		(node as Scene).processing = val


func _set_layer(node: Node) -> void:
	if node is Node2D:
		(node as Node2D).z_index = _next_layer
	elif node is Control:
		(node as Control).z_index = _next_layer


func _get_previous_layer() -> Node:
	return _layer_dict.get(_next_layer - 1)


func _open_multiple(nodes: Array[Node]) -> void:
	for i in nodes.size():
		_open(nodes[i])


func _close(node: Node) -> void:
	if not node:
		return
	if _deregister(node):
		_toggle_visibility(node, false)
		_toggle_processing(node, false)
		_next_layer -= 1
		var restored := _get_previous_layer()
		if restored:
			_toggle_visibility(restored, true)
			_toggle_processing(restored, true)


func _deregister(node: Node) -> bool:
	var idx = _layer_dict.find_key(node)
	if idx != null:
		return _layer_dict.erase(idx)
	return false


func _close_all() -> void:
	for i in _layer_dict.size():
		_close(_layer_dict[i])
