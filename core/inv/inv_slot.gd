class_name InvSlot
extends MarginContainer

signal inv_card_set(_inv_card: InvCard)

const CLICK_DRAG_THRESHOLD := 10.0

static var _ignore_release_pickup := false

@export var inv_card: InvCard = null:
	set(val):
		inv_card = val
		if inv_card:
			connect_card()

var inv_grid: InvGrid = null
var inv_slot := 0
var accepted_card_types: Array[BaseCard.CardType]
var tooltip := "":
	get:
		if inv_card and inv_card.card and inv_card.card.name:
			return inv_card.card.name
		return ""
	set(val):
		tooltip = val
var _press_pos := Vector2.ZERO
var _pressed_on_this_slot := false

@onready var texture_rect: TextureRect = $TextureRect


func _ready() -> void:
	connect_card()
	display_item()


func _gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	var mb := event as InputEventMouseButton
	if event.is_action("primary_input"):
		if mb.pressed:
			_press_pos = mb.position
			_pressed_on_this_slot = true
			return
		if _ignore_release_pickup:
			_ignore_release_pickup = false
			_pressed_on_this_slot = false
			return
		if _should_click_pickup(mb):
			var data: Variant = _make_drag_data()
			if data == null:
				return
			force_drag(data, _get_drag_preview())
			texture_rect.modulate.a = 0.5
			accept_event()
		return
	if event.is_action("secondary_input") and not mb.pressed:
		_open_contextual_menu()


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		_ignore_release_pickup = true
		_on_drag_end(is_drag_successful())


func set_item(_inv_card: InvCard) -> void:
	inv_card = _inv_card
	tooltip_text = tooltip
	display_item()
	inv_card_set.emit(inv_card)


func display_item() -> void:
	texture_rect.modulate.a = 1.0
	if not inv_card or not inv_card.card:
		texture_rect.texture = null
		return
	if inv_card and inv_card.card and inv_card.card.texture:
		texture_rect.texture = inv_card.card.texture


func connect_card() -> void:
	if inv_card and inv_card.card is CardMonster:
		var monster: CardMonster = inv_card.card
		if not monster.reward_granted.is_connected(_on_reward_granted):
			monster.reward_granted.connect(_on_reward_granted)


func _should_click_pickup(mb: InputEventMouseButton) -> bool:
	if not _pressed_on_this_slot:
		return false
	_pressed_on_this_slot = false
	if not inv_card or not inv_card.card:
		return false
	if get_viewport().gui_is_dragging():
		return false
	if _press_pos.distance_to(mb.position) > CLICK_DRAG_THRESHOLD:
		return false
	return true


func _on_drag_end(_successful: bool) -> void:
	display_item()


func _make_drag_data() -> Variant:
	if not inv_card or not inv_card.card:
		return
	return {
		"inv_card": inv_card,
		"from_slot": self,
		"from_grid": inv_grid,
	}


func _get_drag_data(_at_position: Vector2) -> Variant:
	var data = _make_drag_data()
	if not data:
		return null

	set_drag_preview(_get_drag_preview())
	texture_rect.modulate.a = 0.5

	return data


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return inv_grid.can_accept_drop(data, self)


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	inv_grid.handle_drop(data, self)


func _get_drag_preview() -> TextureRect:
	var rect := TextureRect.new()
	rect.texture = inv_card.card.texture
	rect.position += Vector2(5, 5)
	rect.z_index = Global.CANVAS_LAYER

	return rect


func _open_contextual_menu() -> void:
	Global.contextual_menu.toggle_visible(true, self)


func _on_reward_granted() -> void:
	print("would tween here")
