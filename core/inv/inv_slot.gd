class_name InvSlot
extends MarginContainer

signal inv_card_set(_inv_card: InvCard)

const CLICK_DRAG_THRESHOLD := 10.0

static var _ignore_release_pickup := false

@export var inv_card: InvCard = null:
	set(val):
		_disconnect_reward()
		inv_card = val
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
var tween: Tween = null
var _press_pos := Vector2.ZERO
var _pressed_on_this_slot := false

@onready var pivot: Control = $Pivot
@onready var texture_rect: TextureRect = $Pivot/TextureRect


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
			call_deferred("_begin_click_drag", data)
			accept_event()
		return
	if event.is_action("secondary_input") and not mb.pressed:
		_open_contextual_menu()


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		_ignore_release_pickup = true
		_on_drag_end(is_drag_successful())


func set_item(_inv_card: InvCard) -> void:
	if inv_grid is InvHotbar and inv_card and inv_card.card is CardMonster:
		if _inv_card == null or _inv_card != inv_card:
			(inv_card.card as CardMonster).on_removed_from_hotbar()
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


func _disconnect_reward() -> void:
	if inv_card == null or inv_card.card == null or not inv_card.card is CardMonster:
		return
	var monster: CardMonster = inv_card.card
	if monster.reward_granted.is_connected(_on_reward_granted):
		monster.reward_granted.disconnect(_on_reward_granted)


func connect_card() -> void:
	if inv_card == null or inv_card.card == null or not inv_card.card is CardMonster:
		return
	if not inv_grid is InvHotbar:
		return
	var monster: CardMonster = inv_card.card
	if not monster.reward_granted.is_connected(_on_reward_granted):
		monster.reward_granted.connect(_on_reward_granted)


func combined_tween() -> void:
	var _tween := get_tree().create_tween()
	tween = _tween
	_tween.tween_property(pivot, "rotation", PI / 8, 0.2)
	_tween.parallel().tween_property(texture_rect, "scale", Vector2(1.1, 1.1), 0.2)
	_tween.tween_property(pivot, "rotation", 0.0, 0.2)
	_tween.parallel().tween_property(texture_rect, "scale", Vector2.ONE, 0.2)
	await _tween.finished
	tween = null


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


func _begin_click_drag(data: Variant) -> void:
	force_drag(data, _get_drag_preview())
	texture_rect.modulate.a = 0.5


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
	Global.game.contextual_menu.open(self)


func _on_reward_granted() -> void:
	if tween:
		tween.kill()
		tween = null
	await combined_tween()
