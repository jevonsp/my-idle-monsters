extends Node

const CANVAS_LAYER := 20
const AUTOSAVE_INTERVAL := 30.0

var main: Node
var game := GameSession.new()
var saver := SaverLoader.new()
var preferences := Preferences.new()
var currency_save: CurrencySaveParticipant
var player_stats_save: PlayerStatsSaveParticipant
var inventory_save: InventorySaveParticipant
var bootstrapped := false
var _autosave_timer := 0.0


func _ready() -> void:
	_register_saves()


func _process(delta: float) -> void:
	if not bootstrapped:
		return
	_autosave_timer += delta
	if _autosave_timer >= AUTOSAVE_INTERVAL:
		_autosave_timer = 0.0
		try_autosave()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		try_autosave()


func mark_bootstrapped() -> void:
	bootstrapped = true


func try_autosave() -> void:
	if not bootstrapped:
		return
	var viewport := get_viewport()
	if viewport and viewport.gui_is_dragging():
		return
	var err := saver.save_game()
	EventBus.save_completed.emit(err)


func _register_saves() -> void:
	currency_save = CurrencySaveParticipant.new(game.currency)
	player_stats_save = PlayerStatsSaveParticipant.new(game.player_stats)
	inventory_save = InventorySaveParticipant.new()
	saver.register_participant(currency_save)
	saver.register_participant(player_stats_save)
	saver.register_participant(inventory_save)
