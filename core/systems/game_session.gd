class_name GameSession
extends RefCounted

var currency: CurrencyTracker
var player_stats: PlayerStatTracker
var click_tracker: ClickTracker
var unit_manager: UnitManager
var menu_builder: ContextMenuBuilder
var player_stats_display: PlayerStatsDisplay = null
var hot_bar: InvHotbar = null
var player_inv: InvGrid = null
var contextual_menu: ContextualMenu = null
var active_store: InvGrid = null


func _init() -> void:
	currency = CurrencyTracker.new(0.0, 0)
	player_stats = PlayerStatTracker.new(1.0, 0)
	click_tracker = ClickTracker.new()
	unit_manager = UnitManager.new()
	menu_builder = ContextMenuBuilder.new(self)
	unit_manager.bind_game_session(self)


func can_buy(card: BaseCard) -> bool:
	return currency.can_afford(card.base_price)


func can_buy_from_store(card: BaseCard) -> bool:
	return can_buy(card)


func try_buy_from_store(source: InvCard) -> InvCard:
	if not source or not source.card:
		return null
	if not try_buy(source.card):
		return null
	return source.duplicate(true)


func try_sell_to_store(card: BaseCard) -> bool:
	if not card:
		return false
	return try_sell(card)


func try_buy(card: BaseCard) -> bool:
	return currency.spend(card.base_price)


func try_sell(card: BaseCard) -> bool:
	currency.earn(card.base_price)
	return true


func grant_idle_reward(monster: CardMonster) -> void:
	currency.earn(monster.get_idle_reward())
	monster.reward_granted.emit()
	monster.reset_wait_timer()


func grant_click_reward() -> void:
	click_tracker.register_click()
	var quant := player_stats.get_click_power()
	currency.earn(quant)


func get_total_cps() -> BigNumber:
	var monster_cps = unit_manager.get_monster_cps()
	var player_cps = player_stats.get_player_cps().multiply(click_tracker.get_raw_cps())
	return monster_cps.plus(player_cps)


func get_context_actions(slot: InvSlot) -> Array[ContextAction]:
	return menu_builder.get_actions_for_slot(slot)


func run_context_action(action_id: String, slot: InvSlot) -> bool:
	match action_id:
		ContextMenuBuilder.ID_BUY:
			return _context_buy(slot)
		ContextMenuBuilder.ID_SELL:
			return _context_sell(slot)
		_:
			push_warning("Unknown context action: %s" % action_id)
			return false


func _context_buy(slot: InvSlot) -> bool:
	if not slot or not slot.inv_card or not slot.inv_card.card:
		return false
	if not can_buy_from_store(slot.inv_card.card):
		return false
	var item := slot.inv_card
	var bought := try_buy_from_store(item)
	if bought and not player_inv:
		return false
	var to_slot := player_inv.get_first_empty_slot()
	if not to_slot:
		return false
	to_slot.set_item(bought)
	return false


func _context_sell(slot: InvSlot) -> bool:
	if not slot or not slot.inv_card or not slot.inv_card.card:
		return false
	if not active_store:
		return false
	if not try_sell_to_store(slot.inv_card.card):
		return false
	slot.set_item(null)
	return true
