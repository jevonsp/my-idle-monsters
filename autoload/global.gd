extends Node

const CANVAS_LAYER := 20
const AUTOSAVE_INTERVAL := 30.0

var main: Node
var saver := SaverLoader.new()
var click_tracker := ClickTracker.new()
var currency := CurrencyTracker.new(0.0, 0)
var player_stats := PlayerStatTracker.new(1.0, 0)
var unit_manager := UnitManager.new()
var game := GameSession.new()
var preferences := Preferences.new()
var currency_save: CurrencySaveParticipant
var player_stats_save: PlayerStatsSaveParticipant
var inventory_save: InventorySaveParticipant
var player_stats_display: PlayerStatsDisplay = null
var hot_bar: InvHotbar = null
var player_inv: InvGrid = null
var contextual_menu: ContextualMenu = null
var active_store: InvGrid = null
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
	currency_save = CurrencySaveParticipant.new(currency)
	player_stats_save = PlayerStatsSaveParticipant.new(player_stats)
	inventory_save = InventorySaveParticipant.new()
