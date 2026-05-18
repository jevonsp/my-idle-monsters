class_name InvHotbar
extends InvGrid

signal hot_bar_changed(list: Dictionary[int, CardMonster])


func _ready() -> void:
	super()
	Global.hot_bar = self
	Global.unit_manager.connect_signals()
	hot_bar_changed.emit(_construct_list())


## DO OPERATIONS HERE!! NOT IN can_accept_drop() !!
func handle_drop(data: Variant, to_slot: InvSlot) -> void:
	var item: InvCard = data.get("inv_card")
	var from_slot: InvSlot = data.get("from_slot")
	var from_grid: InvGrid = data.get("from_grid")

	var op_complete := false

	while not op_complete:
		if not item or not item.card:
			op_complete = true
			break

		if from_slot == self:
			swap_items(data, to_slot)
			op_complete = true
			break

		if from_slot.inv_grid.inv_type == InvType.PLAYER and inv_type == InvType.PLAYER:
			swap_items(data, to_slot)
			op_complete = true
			break

		if from_grid.inv_type == InvType.STORE and inv_type == InvType.PLAYER:
			if not Global.currency.spend(item.card.base_price):
				op_complete = true
				break
			to_slot.set_item(item.duplicate(true)) # Doesnt modify store in place
			op_complete = true
			break

		if from_grid.inv_type == InvType.PLAYER and inv_type == InvType.STORE:
			Global.currency.earn(item.card.base_price)
			from_slot.set_item(null)
			op_complete = true
			break

	if from_slot and from_slot.inv_card:
		var card = from_slot.inv_card.card
		if card and card is CardMonster:
			(card as CardMonster).wait_timer = 0.0

	if to_slot and to_slot.inv_card:
		var card = to_slot.inv_card.card
		if card and card is CardMonster:
			(card as CardMonster).wait_timer = 0.0

	hot_bar_changed.emit(_construct_list())


func swap_items(data: Variant, to_slot: InvSlot) -> void:
	var from_slot = data.get("from_slot")
	super.swap_items(data, to_slot)
	if from_slot.inv_grid == Global.hot_bar:
		_notify_card_left_hotbar(from_slot)


func _construct_list() -> Dictionary[int, CardMonster]:
	var fmt: Dictionary[int, CardMonster] = { }

	for i in slot_list.size():
		var inv := slot_list[i].inv_card
		if inv and inv.card is CardMonster:
			fmt[i] = inv.card as CardMonster

	return fmt


func _notify_card_left_hotbar(slot: InvSlot) -> void:
	var card := slot.inv_card.card if slot.inv_card else null
	if card is CardMonster:
		(card as CardMonster).on_removed_from_hotbar()
