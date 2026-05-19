class_name ContextMenuBuilder
extends RefCounted

const ID_BUY := "buy"
const ID_SELL := "sell"
const ID_EQUIP := "equip"
const ID_UNEQUIP := "unequip"

var game: GameSession


func _init(
		_game: GameSession,
) -> void:
	game = _game


func get_actions_for_slot(slot: InvSlot) -> Array[ContextAction]:
	var actions: Array[ContextAction] = []
	if not _has_card(slot):
		return actions

	var grid := slot.inv_grid

	if _can_equip_from(grid):
		actions.append(ContextAction.new(ID_EQUIP, "Equip"))

	if _can_unequip_from(grid):
		actions.append(ContextAction.new(ID_UNEQUIP, "Un-Equip"))

	if _can_buy_from(grid):
		actions.append(ContextAction.new(ID_BUY, "Buy"))

	if _can_sell_from(grid):
		actions.append(ContextAction.new(ID_SELL, "Sell"))

	return actions


func _has_card(slot: InvSlot) -> bool:
	return (
		slot != null and
		slot.inv_card != null and
		slot.inv_card.card != null
	)


func _can_buy_from(grid: InvGrid) -> bool:
	return grid.inv_type == InvGrid.InvType.STORE


func _can_sell_from(grid: InvGrid) -> bool:
	return grid.inv_type == InvGrid.InvType.PLAYER and game.active_store


func _can_equip_from(grid: InvGrid) -> bool:
	if grid.inv_type == InvGrid.InvType.STORE:
		return false
	if grid is InvHotbar:
		return false
	return true


func _can_unequip_from(grid: InvGrid) -> bool:
	if grid.inv_type == InvGrid.InvType.STORE:
		return false
	if grid is InvHotbar:
		return true
	return false
