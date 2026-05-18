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
	return _currency.spend(card.base_price)


func try_sell(card: BaseCard) -> bool:
	_currency.earn(card.base_price)
	return true


func grant_idle_reward(monster: CardMonster) -> void:
	_currency.earn(monster.get_idle_reward())
	monster.reset_wait_timer()


func grant_click_reward() -> void:
	var quant := _player_stats.calculate_click_power()
	_currency.earn(quant)
