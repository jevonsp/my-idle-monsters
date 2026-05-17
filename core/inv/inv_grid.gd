class_name InvGrid
extends GridContainer

const INV_SLOT = preload("uid://pjbq0neklcw1")

@export var inv_list: Dictionary[int, InvItem] = { }
@export var num_slots := 20

var slot_list: Array[InvSlot] = []


func _ready() -> void:
	_prepare_slots()
	_display_slots()


func _prepare_slots() -> void:
	for i in range(num_slots):
		var slot: InvSlot = INV_SLOT.instantiate()
		add_child(slot)
		slot_list.append(slot)


func _display_slots() -> void:
	for key in inv_list.keys():
		if key >= num_slots:
			return
		if not slot_list.get(key):
			return
		slot_list[key].set_item(inv_list[key])
