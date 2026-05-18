class_name InvHotbar
extends InvGrid


func _ready() -> void:
	super()
	Global.hot_bar = self


func get_monster_list() -> Dictionary[int, CardMonster]:
	var fmt: Dictionary[int, CardMonster] = { }

	for i in slot_list.size():
		var inv := slot_list[i].inv_card
		if inv and inv.card is CardMonster:
			fmt[i] = inv.card as CardMonster

	return fmt


func notify_hotbar_changed() -> void:
	EventBus.hotbar_changed.emit(get_monster_list())


## DO OPERATIONS HERE!! NOT IN can_accept_drop() !!
func handle_drop(data: Variant, to_slot: InvSlot) -> void:
	var from_slot: InvSlot = data.get("from_slot")
	super.handle_drop(data, to_slot)
	Global.game.on_hotbar_layout_changed(from_slot, to_slot)
	notify_hotbar_changed()


func swap_items(data: Variant, to_slot: InvSlot) -> void:
	var from_slot: InvSlot = data.get("from_slot")
	super.swap_items(data, to_slot)
	if from_slot.inv_grid == Global.hot_bar:
		_notify_card_left_hotbar(from_slot)
	notify_hotbar_changed()


func _notify_card_left_hotbar(slot: InvSlot) -> void:
	var card := slot.inv_card.card if slot.inv_card else null
	if card is CardMonster:
		(card as CardMonster).on_removed_from_hotbar()
