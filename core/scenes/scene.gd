class_name Scene
extends Control

var processing := false:
	set(val):
		processing = val
		print("%s: %s" % [name, processing])
var back_button: Button


func _ready() -> void:
	var node = get_node_or_null("BackButton")
	if node:
		back_button = node
		if not back_button.pressed.is_connected(_on_back_button_pressed):
			back_button.pressed.connect(_on_back_button_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if not processing:
		return
	if event.is_action_pressed("no"):
		_close_scene()


func set_scene_layout() -> void:
	pass


func revert_to_main_layout() -> void:
	print("revert to main layout")
	EventBus.request_layout.emit(
		Global.game.player_inv,
		Control.LayoutPreset.PRESET_CENTER_TOP,
		0,
		true,
	)


func _on_back_button_pressed() -> void:
	_close_scene()


func _close_scene() -> void:
	EventBus.screen_manager_toggle.emit(self, false)
	get_viewport().set_input_as_handled()
