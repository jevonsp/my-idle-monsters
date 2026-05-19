class_name GameBootstrap
extends RefCounted


static func setup() -> void:
	if Global.saver.save_game_exists():
		Global.saver.load_game()
	Global.game.initialize(
		Global.currency,
		Global.unit_manager,
		Global.player_stats,
		Global.click_tracker,
	)
	Global.game.unit_manager.bind(Global.game)
	Global.game.unit_manager.connect_signals()
	Global.game.click_tracker.connect_signals()
	Global.game.player_stats_display.connect_signals()
	_refresh_ui_after_load()
	Global.mark_bootstrapped()


static func _refresh_ui_after_load() -> void:
	if Global.game.player_inv:
		Global.game.player_inv.reload_from_slots()
	if Global.game.hot_bar:
		Global.game.hot_bar.reload_from_slots()
	EventBus.game_loaded.emit()
	_sync_hotbar()


static func _sync_hotbar() -> void:
	if Global.game.hot_bar:
		EventBus.hotbar_changed.emit(Global.game.hot_bar.get_monster_list())
