class_name PlayerStatTracker
extends RefCounted

var power := BigNumber.new()


func _init(m: float, e: int) -> void:
	power.mantissa = m
	power.exponent = e


func calculate_click_power() -> BigNumber:
	var bn := BigNumber.new()
	return bn


func connect_signals() -> void:
	if not Global.main_button.pressed.is_connected(_on_main_button_pressed):
		Global.main_button.pressed.connect(_on_main_button_pressed)


func _on_main_button_pressed() -> void:
	Global.game.grant_click_reward()
