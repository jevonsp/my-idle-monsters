class_name InvSlot
extends MarginContainer

signal inv_item_set(_inv_item: InvItem)

@export var inv_item: InvItem = null

@onready var texture_rect: TextureRect = $TextureRect


func _ready() -> void:
	display_item()


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		var ok := is_drag_successful()
		_on_drag_end(ok)


func set_item(_inv_item: InvItem) -> void:
	inv_item = _inv_item
	display_item()
	inv_item_set.emit(inv_item)
	print("changed")


func display_item() -> void:
	texture_rect.modulate.a = 1.0
	if not inv_item:
		texture_rect.texture = null
		return
	if inv_item and inv_item.texture:
		texture_rect.texture = inv_item.texture


func _on_drag_end(successful: bool) -> void:
	if successful:
		return
	display_item()


func _get_drag_data(_at_position: Vector2) -> Variant:
	if not inv_item:
		return
	var data := {
		"item": inv_item,
		"slot": self,
	}

	set_drag_preview(_get_drag_preview())
	texture_rect.modulate.a = 0.5

	return data


func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return inv_item == null


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	set_item(data.get("item"))
	var slot: InvSlot = data.get("slot")
	if slot:
		slot.set_item(null)


func _get_drag_preview() -> TextureRect:
	var rect := TextureRect.new()
	rect.texture = inv_item.texture
	rect.position += Vector2(5, 5)
	rect.z_index = Global.CANVAS_LAYER

	return rect
