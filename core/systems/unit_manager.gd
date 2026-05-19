class_name UnitManager
extends RefCounted

var game: GameSession
var cards: Dictionary[int, CardMonster] = { }


func bind(_game: GameSession) -> void:
	game = _game


func connect_signals() -> void:
	if not EventBus.hotbar_changed.is_connected(_on_hotbar_changed):
		EventBus.hotbar_changed.connect(_on_hotbar_changed)
	if not EventBus.time_ticked.is_connected(_on_time_ticked):
		EventBus.time_ticked.connect(_on_time_ticked)


func get_monster_cps() -> BigNumber:
	var ttl := BigNumber.new()
	ttl.mantissa = 0.0

	for monster: CardMonster in cards.values():
		ttl.plus_equals(monster.get_idle_cps())

	return ttl


func _on_hotbar_changed(list: Dictionary) -> void:
	cards = list


func _on_time_ticked(delta: float) -> void:
	for key: int in cards:
		var monster: CardMonster = cards[key]
		monster.wait_timer += delta
		if monster.is_ready:
			game.grant_idle_reward(monster)
