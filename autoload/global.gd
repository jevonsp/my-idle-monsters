extends Node

const CANVAS_LAYER := 20

var main: Node
var currency := CurrencyTracker.new(0.0, 0)
var player_stats := PlayerStatTracker.new(1.0, 0)
var unit_manager := UnitManager.new()
var active_store: InvGrid = null
var contextual_menu: ContextualMenu = null
var main_button: MainButton = null
var hot_bar: InvHotbar = null


func _ready() -> void:
	pass
