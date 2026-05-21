extends Node

@warning_ignore_start("unused_signal")
signal game_loaded
signal save_completed(error: Error)
signal time_ticked(delta: float)
signal currency_changed(money: BigNumber)
signal hotbar_changed(cards: Dictionary)
signal screen_manager_toggle(scene: Scene, val: bool)
signal request_layout(node: Node, preset: Control.LayoutPreset, margin: int, visible: bool)


@warning_ignore_restore("unused_signal")
func _process(delta: float) -> void:
	time_ticked.emit(delta)
