class_name InvGrid
extends GridContainer

enum InvType { PLAYER, STORE }

const INV_SLOT = preload("uid://pjbq0neklcw1")

@export var inv_type := InvType.PLAYER
@export var inv_list: Dictionary[int, InvItem] = { }
@export var num_slots := 15
@export var accepted_inventory_types: Array[InvItem.ItemType] = [
	InvItem.ItemType.MONSTER,
	InvItem.ItemType.ITEM,
	InvItem.ItemType.GEAR,
]

var processing := visible
var slot_list: Array[InvSlot] = []


func _ready() -> void:
	_prepare_slots()
	_set_slots()
	if visible:
		_register_store()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("no"):
		if inv_type == InvType.STORE:
			toggle_visible(false)


## WARNING NEVER EVER DO OPS HERE. ONLY CHECK VALIDITY!
func can_accept_drop(data: Variant, to_slot: InvSlot) -> bool:
	if to_slot.inv_item:
		if can_swap_items(data, to_slot):
			return true

	var from_grid: InvGrid = data.get("from_grid")
	var item: InvItem = data.get("inv_item")

	if item.item_type not in to_slot.accepted_item_types:
		print("not in accepted item types")
		return false

	if inv_type == InvType.PLAYER:
		if from_grid.inv_type == InvType.STORE:
			if not Global.currency_tracker.can_afford(item.base_price):
				print("not enough money")
				return false

		elif from_grid.inv_type == InvType.PLAYER and to_slot.inv_item == null:
			print("inside own invent and slot is empty")
			return true

	elif inv_type == InvType.STORE:
		if from_grid.inv_type == InvType.STORE:
			print("cant move store items around")
			return false

	return to_slot.inv_item == null


func can_swap_items(data: Variant, _to_slot: InvSlot) -> bool:
	var _from_grid: InvGrid = data.get("from_grid")
	var _item: InvItem = data.get("inv_item")
	if inv_type == InvType.STORE:
		return false
	return true


## DO OPERATIONS HERE!! NOT IN can_accept_drop() !!
func handle_drop(data: Variant, to_slot: InvSlot) -> void:
	var item: InvItem = data.get("inv_item")
	var from_slot: InvSlot = data.get("from_slot")
	var from_grid: InvGrid = data.get("from_grid")

	if from_slot == self:
		swap_items(data, to_slot)
		return

	if from_slot.inv_grid.inv_type == InvType.PLAYER and inv_type == InvType.PLAYER:
		swap_items(data, to_slot)
		return

	if from_grid.inv_type == InvType.STORE and inv_type == InvType.PLAYER:
		if not Global.currency_tracker.spend(item.base_price):
			return
		to_slot.set_item(item.duplicate()) # Doesnt modify store in place
		return

	if from_grid.inv_type == InvType.PLAYER and inv_type == InvType.STORE:
		Global.currency_tracker.earn(item.base_price)
		from_slot.set_item(null)
		return


func swap_items(data: Variant, to_slot: InvSlot) -> void:
	var from_slot: InvSlot = data.get("from_slot")
	var from_item: InvItem = data.get("inv_item")
	var to_item: InvItem = to_slot.inv_item
	from_slot.set_item(to_item)
	to_slot.set_item(from_item)


func toggle_visible(val: bool) -> void:
	processing = val
	visible = val
	if visible:
		_register_store()
		return
	_deregister_store()


func _prepare_slots() -> void:
	for i in range(num_slots):
		var slot: InvSlot = INV_SLOT.instantiate()
		add_child(slot)
		slot_list.append(slot)
		slot.inv_grid = self
		slot.accepted_item_types = accepted_inventory_types.duplicate()


func _set_slots() -> void:
	for key in inv_list.keys():
		if key >= num_slots:
			continue
		if not slot_list.get(key):
			continue
		slot_list[key].set_item(inv_list[key])


func _register_store() -> bool:
	if inv_type == InvType.STORE:
		Global.active_store = self
		return true
	return false


func _deregister_store() -> void:
	Global.active_store = null
