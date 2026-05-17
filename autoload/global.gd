extends Node

const CANVAS_LAYER := 20

var main: Node
var currency_tracker := CurrencyTracker.new(0.0, 0)
var active_store: InvGrid = null
var contextual_menu: ContextualMenu = null
