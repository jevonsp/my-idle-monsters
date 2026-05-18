class_name UnitManager
extends RefCounted

var cards: Dictionary[int, CardMonster] = { }


func connect_signals() -> void:
	if not EventBus.hotbar_changed.is_connected(_on_hotbar_changed):
		EventBus.hotbar_changed.connect(_on_hotbar_changed)
	if not EventBus.time_ticked.is_connected(_on_time_ticked):
		EventBus.time_ticked.connect(_on_time_ticked)


func _on_hotbar_changed(list: Dictionary) -> void:
	cards = list


func _on_time_ticked(delta: float) -> void:
	for key: int in cards:
		var monster: CardMonster = cards[key]
		monster.wait_timer += delta
		if monster.is_ready:
			Global.game.grant_idle_reward(monster)
