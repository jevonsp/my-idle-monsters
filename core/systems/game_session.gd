class_name GameSession
extends RefCounted

var currency: CurrencyTracker
var player_stats: PlayerStatTracker
var click_tracker: ClickTracker
var unit_manager: UnitManager
var menu_builder: ContextMenuBuilder
var context_action_runner: ContextActionRunner
var screen_manager: ScreenManager
var player_stats_display: PlayerStatsDisplay = null
var hot_bar: InvHotbar = null
var player_inv: InvGrid = null
var contextual_menu: ContextualMenu = null
var active_store: InvGrid = null
var store_scene: StoreScene = null
var job_scene: JobScene = null
var fight_scene: FightScene = null


func _init() -> void:
	currency = CurrencyTracker.new(0.0, 0)
	player_stats = PlayerStatTracker.new(1.0, 0)
	click_tracker = ClickTracker.new()
	unit_manager = UnitManager.new()
	menu_builder = ContextMenuBuilder.new(self)
	context_action_runner = ContextActionRunner.new()
	unit_manager.bind_game_session(self)
	screen_manager = ScreenManager.new()


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


func get_idle_cps() -> BigNumber:
	return unit_manager.get_monster_cps()


func get_click_cps() -> BigNumber:
	return player_stats.get_player_cps().multiply(click_tracker.get_raw_cps())


func get_total_cps() -> BigNumber:
	return get_idle_cps().plus(get_click_cps())


func get_context_actions(slot: InvSlot) -> Array[ContextAction]:
	return menu_builder.get_actions_for_slot(slot)


func run_context_action(action_id: String, slot: InvSlot) -> bool:
	match action_id:
		ContextMenuBuilder.ID_EQUIP:
			return context_action_runner.context_equip(slot, self)
		ContextMenuBuilder.ID_UNEQUIP:
			return context_action_runner.context_unequip(slot, self)
		ContextMenuBuilder.ID_BUY:
			return context_action_runner.context_buy(slot, self)
		ContextMenuBuilder.ID_SELL:
			return context_action_runner.context_sell(slot, self)
		_:
			push_warning("Unknown context action: %s" % action_id)
			return false
