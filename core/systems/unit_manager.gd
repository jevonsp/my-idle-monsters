class_name UnitManager
extends RefCounted

var cards: Dictionary[int, CardMonster] = { }


func _init() -> void:
	pass


func connect_signals() -> void:
	if not Global.hot_bar.hot_bar_changed.is_connected(_on_hot_bar_changed):
		Global.hot_bar.hot_bar_changed.connect(_on_hot_bar_changed)
	if not EventBus.time_ticked.is_connected(_on_time_ticked):
		EventBus.time_ticked.connect(_on_time_ticked)


func _on_hot_bar_changed(list: Dictionary[int, CardMonster]) -> void:
	cards = list


func _on_time_ticked(delta: float) -> void:
	for key: int in cards:
		var monster: CardMonster = cards[key]
		monster.wait_timer += delta
		if monster.is_ready:
			monster.on_wait_timer_finished()
