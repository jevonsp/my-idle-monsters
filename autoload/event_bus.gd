extends Node

@warning_ignore_start("unused_signal")
signal time_ticked(delta: float)
signal currency_changed(money: BigNumber)
signal hotbar_changed(cards: Dictionary)
@warning_ignore_restore("unused_signal")


func _process(delta: float) -> void:
	time_ticked.emit(delta)
