class_name ContextualMenu
extends VBoxContainer

const BUTTON_SCENE = preload("uid://b3fkqib2omlii")

var processing := visible
var buttons: Array[Button] = []
var inv_slot: InvSlot = null


func _ready() -> void:
	Global.game.contextual_menu = self


func _process(_delta: float) -> void:
	if not visible:
		return
	var mouse_pos := get_viewport().get_mouse_position()
	var center_pos := get_global_rect().get_center()
	var dist := mouse_pos - center_pos
	if abs(dist.x) >= 60 or abs(dist.y) >= 50:
		close()


func open(slot: InvSlot) -> void:
	var actions := Global.game.get_context_actions(slot)
	if actions.is_empty():
		return

	inv_slot = slot
	_build_buttons(actions)
	global_position = get_viewport().get_mouse_position() + Vector2(0, -20)
	processing = true
	visible = true


func close() -> void:
	processing = false
	visible = false
	inv_slot = null
	_clear_buttons()


func _build_buttons(actions: Array[ContextAction]) -> void:
	_clear_buttons()
	for action in actions:
		var btn: Button = BUTTON_SCENE.instantiate()
		btn.text = action.label
		btn.disabled = not action.enabled
		btn.pressed.connect(_on_action_pressed.bind(action.id))
		add_child(btn)
		buttons.append(btn)


func _clear_buttons() -> void:
	for btn in buttons:
		btn.queue_free()
	buttons.clear()


func _on_action_pressed(action_id: String) -> void:
	if inv_slot:
		Global.game.run_context_action(action_id, inv_slot)
	close()
