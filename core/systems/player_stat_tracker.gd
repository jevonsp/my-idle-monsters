class_name PlayerStatTracker
extends RefCounted

var power := BigNumber.new()


func _init(m: float, e: int) -> void:
	power.mantissa = m
	power.exponent = e


func get_click_power() -> BigNumber:
	return power


func get_player_cps() -> BigNumber:
	return power
