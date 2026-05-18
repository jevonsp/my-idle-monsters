class_name CurrencyTracker
extends RefCounted

var money := BigNumber.new():
	set(val):
		money = val
		_notify_changed()


func _init(m: float, e: int) -> void:
	money.mantissa = m
	money.exponent = e


func load_from_save(mantissa: float, exponent: int) -> void:
	money.mantissa = mantissa
	money.exponent = exponent
	_notify_changed()


func spend(price: BigNumber) -> bool:
	if not can_afford(price):
		return false
	decrement_money(price)
	return true


func earn(amount: BigNumber) -> void:
	money.plus_equals(amount)
	_notify_changed()


func can_afford(price: BigNumber) -> bool:
	return price.is_less_than_or_equal_to(money)


func increment_money(amount: BigNumber) -> void:
	money.plus_equals(amount)
	_notify_changed()


func decrement_money(amount: BigNumber) -> void:
	money.minus_equals(amount)
	_notify_changed()


func _notify_changed() -> void:
	EventBus.currency_changed.emit(money)
