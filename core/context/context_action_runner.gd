class_name ContextActionRunner
extends RefCounted


func context_buy(slot: InvSlot, game: GameSession) -> bool:
	if not slot or not slot.inv_card or not slot.inv_card.card:
		return false
	if not game.can_buy_from_store(slot.inv_card.card):
		return false
	var item := slot.inv_card
	var bought := game.try_buy_from_store(item)
	if bought and not game.player_inv:
		return false
	var to_slot := game.player_inv.get_first_empty_slot()
	if not to_slot:
		return false
	to_slot.set_item(bought)
	return true


func context_sell(slot: InvSlot, game: GameSession) -> bool:
	if not slot or not slot.inv_card or not slot.inv_card.card:
		return false
	if not game.active_store:
		return false
	if not game.try_sell_to_store(slot.inv_card.card):
		return false
	slot.set_item(null)
	return true


func context_equip(slot: InvSlot, game: GameSession) -> bool:
	var hb_slot := game.hot_bar.get_first_empty_slot()
	if hb_slot == null:
		return false
	hb_slot.set_item(slot.inv_card.duplicate(true))
	slot.set_item(null)
	return true


func context_unequip(slot: InvSlot, game: GameSession) -> bool:
	var inv_slot := game.player_inv.get_first_empty_slot()
	if inv_slot == null:
		return false
	var item := slot.inv_card
	slot.set_item(null)
	inv_slot.set_item(item)
	return true
