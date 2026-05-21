class_name GameBootstrap
extends RefCounted


static func setup() -> void:
	if Global.saver.save_game_exists():
		Global.saver.load_game()

	_set_ui_nodes()
	_set_scene_nodes()
	_connect_signals()

	_refresh_ui_after_load()
	Global.mark_bootstrapped()


static func _set_ui_nodes() -> void:
	var game = Global.game
	var main = Global.main

	game.canvas_layer = main.get_node_or_null(main.canvas_layer_path)
	game.player_inv = main.get_node_or_null(main.player_inv)
	game.hot_bar = main.get_node_or_null(main.hot_bar)
	game.player_stats_display = main.get_node_or_null(main.player_stats_display)
	game.contextual_menu = main.get_node_or_null(main.contextual_menu)


static func _set_scene_nodes() -> void:
	var store_node = Global.main.get_node_or_null(Global.main.store_path)
	if store_node:
		Global.game.store_scene = store_node

	var job_node = Global.main.get_node_or_null(Global.main.job_path)
	if job_node:
		Global.game.job_scene = job_node

	var fight_node = Global.main.get_node_or_null(Global.main.fight_path)
	if fight_node:
		Global.game.fight_scene = fight_node


static func _connect_signals() -> void:
	Global.game.unit_manager.connect_signals()
	Global.game.click_tracker.connect_signals()
	Global.game.player_stats_display.connect_signals()
	Global.game.canvas_layer.connect_signals()


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
