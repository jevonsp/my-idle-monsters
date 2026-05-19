class_name GameSession
extends RefCounted

var currency: CurrencyTracker
var player_stats: PlayerStatTracker
var click_tracker: ClickTracker
var unit_manager: UnitManager
var player_stats_display: PlayerStatsDisplay = null
var hot_bar: InvHotbar = null
var player_inv: InvGrid = null
var contextual_menu: ContextualMenu = null
var active_store: InvGrid = null


func initialize(
		_currency: CurrencyTracker,
		_unit_manager: UnitManager,
		_player_stats: PlayerStatTracker,
		_click_tracker: ClickTracker,
) -> void:
	currency = _currency
	unit_manager = _unit_manager
	player_stats = _player_stats
	click_tracker = _click_tracker


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
