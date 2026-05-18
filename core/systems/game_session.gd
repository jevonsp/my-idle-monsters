class_name GameSession
extends RefCounted

var _currency: CurrencyTracker
var _player_stats: PlayerStatTracker


func initialize(
	currency: CurrencyTracker,
	_unit_manager: UnitManager,
	player_stats: PlayerStatTracker,
) -> void:
	_currency = currency
	_player_stats = player_stats


func can_buy(card: BaseCard) -> bool:
	return _currency.can_afford(card.base_price)


func try_buy(card: BaseCard) -> bool:
	if not _currency.spend(card.base_price):
		return false
	_emit_currency_changed()
	return true


func try_sell(card: BaseCard) -> bool:
	_currency.earn(card.base_price)
	_emit_currency_changed()
	return true


func grant_idle_reward(monster: CardMonster) -> void:
	_currency.earn(monster.get_idle_reward())
	monster.reset_wait_timer()
	_emit_currency_changed()


func grant_click_reward() -> void:
	var quant := _player_stats.calculate_click_power()
	_currency.earn(quant)
	_emit_currency_changed()


func sell_from_context(slot: InvSlot) -> bool:
	if not slot or not slot.inv_card or not slot.inv_card.card:
		return false
	if not Global.active_store:
		return false
	try_sell(slot.inv_card.card)
	slot.set_item(null)
	return true


func on_hotbar_layout_changed(from_slot: InvSlot, to_slot: InvSlot) -> void:
	if from_slot and from_slot.inv_card:
		var card := from_slot.inv_card.card
		if card is CardMonster:
			(card as CardMonster).wait_timer = 0.0
	if to_slot and to_slot.inv_card:
		var card := to_slot.inv_card.card
		if card is CardMonster:
			(card as CardMonster).wait_timer = 0.0


func _emit_currency_changed() -> void:
	EventBus.currency_changed.emit(_currency.money)
