class_name GameBootstrap
extends RefCounted


static func setup() -> void:
	Global.game.initialize(Global.currency, Global.unit_manager, Global.player_stats)
	Global.unit_manager.connect_signals()
	Global.player_stats.connect_signals()
	Global.player_stats_display.connect_signals()
	_sync_hotbar()


static func _sync_hotbar() -> void:
	if Global.hot_bar:
		EventBus.hotbar_changed.emit(Global.hot_bar.get_monster_list())
