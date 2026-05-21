class_name SceneManager
extends RefCounted

var _layer_dict: Dictionary[int, Scene] = { }
var _next_layer: int = 0


func _init() -> void:
	_connect_signals()


func _connect_signals() -> void:
	if not EventBus.screen_manager_toggle.is_connected(_on_screen_manager_toggle):
		EventBus.screen_manager_toggle.connect(_on_screen_manager_toggle)


func _on_screen_manager_toggle(scene: Scene, val: bool) -> void:
	if not scene:
		return
	if not val:
		_close(scene)
		return
	_open(scene)


func _open(scene: Scene) -> void:
	_register(scene)
	_set_layer(scene)
	_toggle_visibility(scene, true)
	_toggle_processing(scene, true)
	scene.set_scene_layout()
	var prev := _get_previous_layer()
	if prev:
		_toggle_visibility(prev, false)
		_toggle_processing(prev, false)
	_next_layer += 1


func _register(scene: Scene) -> void:
	_layer_dict[_next_layer] = scene


func _toggle_visibility(scene: Scene, val: bool) -> void:
	scene.visible = val


func _toggle_processing(scene: Scene, val: bool) -> void:
	scene.processing = val


func _set_layer(scene: Scene) -> void:
	scene.z_index = _next_layer


func _get_previous_layer() -> Scene:
	return _layer_dict.get(_next_layer - 1)


func _open_multiple(scenes: Array[Scene]) -> void:
	for i in scenes.size():
		_open(scenes[i])


func _close(scene: Scene) -> void:
	if not scene:
		return
	if _deregister(scene):
		_toggle_visibility(scene, false)
		_toggle_processing(scene, false)
		scene.revert_to_main_layout()
		_next_layer -= 1
		var restored := _get_previous_layer()
		if restored:
			_toggle_visibility(restored, true)
			_toggle_processing(restored, true)
			scene.set_scene_layout()


func _deregister(scene: Scene) -> bool:
	var idx = _layer_dict.find_key(scene)
	if idx != null:
		return _layer_dict.erase(idx)
	return false


func _close_all() -> void:
	for i in _layer_dict.size():
		_close(_layer_dict[i])
