class_name PlayerStatsDisplay
extends Control

@onready var currency_label: Label = $CurrencyLabel


func _ready() -> void:
	Global.player_stats_display = self


func connect_signals() -> void:
	if not EventBus.currency_changed.is_connected(_on_currency_changed):
		EventBus.currency_changed.connect(_on_currency_changed)
	if not EventBus.game_loaded.is_connected(_on_game_loaded):
		EventBus.game_loaded.connect(_on_game_loaded)
	_on_currency_changed(Global.currency.money)


func _on_game_loaded() -> void:
	_on_currency_changed(Global.currency.money)


func _on_currency_changed(_money: BigNumber) -> void:
	currency_label.text = Global.currency.money.to_scientific()
