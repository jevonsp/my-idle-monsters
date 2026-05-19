class_name PlayerStatsDisplay
extends Control

@onready var currency_label: Label = $VBoxContainer/CurrencyLabel
@onready var cps_label: Label = $VBoxContainer/CpsLabel


func _ready() -> void:
	Global.game.player_stats_display = self


func connect_signals() -> void:
	if not EventBus.currency_changed.is_connected(_on_currency_changed):
		EventBus.currency_changed.connect(_on_currency_changed)
	if not EventBus.game_loaded.is_connected(_on_game_loaded):
		EventBus.game_loaded.connect(_on_game_loaded)
	if not EventBus.time_ticked.is_connected(_on_time_ticked):
		EventBus.time_ticked.connect(_on_time_ticked)
	_on_currency_changed(Global.game.currency.money)


func _on_game_loaded() -> void:
	_on_currency_changed(Global.game.currency.money)


func _on_currency_changed(money: BigNumber) -> void:
	currency_label.text = "Money: %s" % [money.to_scientific()]


func _on_time_ticked(_delta: float) -> void:
	cps_label.text = _format_cps_label()


func _format_cps_label() -> String:
	var game := Global.game
	var idle := game.get_idle_cps()
	var text := "Idle CPS: %s" % idle.to_string()
	var raw_click := game.click_tracker.get_raw_cps()
	if raw_click > 0.0:
		text += " | Click: %s" % game.get_click_cps().to_string()
		text += " | Total: %s" % game.get_total_cps().to_string()
	return text
