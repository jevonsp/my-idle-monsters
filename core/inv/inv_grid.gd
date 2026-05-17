class_name InvGrid
extends GridContainer

enum InvType { PLAYER, STORE }

const INV_SLOT = preload("uid://pjbq0neklcw1")

@export var inv_type := InvType.PLAYER
@export var inv_list: Dictionary[int, InvItem] = { }
@export var num_slots := 15

var slot_list: Array[InvSlot] = []


func _ready() -> void:
	_prepare_slots()
	_set_slots()


func can_accept_drop(data: Variant, to_slot: InvSlot) -> bool:
	if to_slot.inv_item:
		return false
	var from: InvGrid = data.get("from_grid")
	var item: InvItem = data.get("inv_item")

	if inv_type == InvType.PLAYER:
		if from.inv_type == InvType.STORE:
			if not Global.currency_tracker.can_afford(item.base_price):
				return false
		elif from.inv_type == InvType.PLAYER and to_slot.inv_item == null:
			return true
	elif inv_type == InvType.STORE:
		if from.inv_type == InvType.STORE:
			return false # This disallows dragging within a store

	return to_slot.inv_item == null


func handle_drop(data: Variant, to: InvSlot) -> void:
	var item: InvItem = data.get("inv_item")
	var from: InvSlot = data.get("from_slot")
	var grid: InvGrid = data.get("from_grid")

	if from == self:
		to.set_item(item)
		from.set_item(null)
		return

	if grid.inv_type == InvType.STORE and inv_type == InvType.PLAYER:
		if not Global.currency_tracker.spend(item.base_price):
			return
		to.set_item(item.duplicate()) # Doesnt modify store in place
		return

	if grid.inv_type == InvType.PLAYER and inv_type == InvType.STORE:
		Global.currency_tracker.earn(item.base_price)
		from.set_item(null)


func _prepare_slots() -> void:
	for i in range(num_slots):
		var slot: InvSlot = INV_SLOT.instantiate()
		add_child(slot)
		slot_list.append(slot)
		slot.inv_grid = self


func _set_slots() -> void:
	for key in inv_list.keys():
		if key >= num_slots:
			return
		if not slot_list.get(key):
			return
		slot_list[key].set_item(inv_list[key])
