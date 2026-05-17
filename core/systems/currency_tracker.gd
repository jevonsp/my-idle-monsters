class_name CurrencyTracker
extends RefCounted

var money := BigNumber.new()


func _init(m: float, e: int) -> void:
	money.mantissa = m
	money.exponent = e


func spend(price: BigNumber) -> bool:
	if not can_afford(price):
		return false
	decrement_money(price)
	return true


func earn(amount: BigNumber) -> void:
	money.plus_equals(amount)


func can_afford(price: BigNumber) -> bool:
	return price.is_less_than_or_equal_to(money)


func increment_money(amount: BigNumber) -> void:
	money.plus_equals(amount)


func decrement_money(amount: BigNumber) -> void:
	money.minus_equals(amount)
