class_name ContextualMenu
extends VBoxContainer

var processing := visible
var buttons: Array[Button] = []
var inv_slot: InvSlot = null


func _ready() -> void:
	Global.contextual_menu = self
	for child in get_children():
		if child is Button:
			buttons.append(child)
	for b in buttons:
		if not b.pressed.is_connected(toggle_visible):
			b.pressed.connect(toggle_visible.bind(false))


func _process(_delta: float) -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	var center_pos := get_global_rect().get_center()
	var dist := mouse_pos - center_pos
	if abs(dist.x) >= 60 or abs(dist.y) >= 50:
		toggle_visible(false)


func toggle_visible(val: bool, _inv_slot: InvSlot = null, _data: Dictionary = { }) -> void:
	processing = val
	visible = processing
	if visible:
		if _inv_slot:
			inv_slot = _inv_slot
		global_position = get_viewport().get_mouse_position()
		return
	inv_slot = null


func _on_sell_pressed() -> void:
	if inv_slot and inv_slot.inv_card and inv_slot.inv_card.card and Global.active_store:
		Global.currency_tracker.earn(inv_slot.inv_card.card.base_price)
		inv_slot.set_item(null)
