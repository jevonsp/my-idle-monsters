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
	Global.unit_manager.connect_signals()
	Global.click_tracker.connect_signals()
	Global.player_stats_display.connect_signals()
	_refresh_ui_after_load()
	Global.mark_bootstrapped()


static func _refresh_ui_after_load() -> void:
	if Global.player_inv:
		Global.player_inv.reload_from_slots()
	if Global.hot_bar:
		Global.hot_bar.reload_from_slots()
	EventBus.game_loaded.emit()
	_sync_hotbar()


static func _sync_hotbar() -> void:
	if Global.hot_bar:
		EventBus.hotbar_changed.emit(Global.hot_bar.get_monster_list())
