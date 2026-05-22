class_name InvJobGrid
extends InvGrid

@export var num_job_slots := 1


func _ready() -> void:
	_set_num_slots()
	super()
	_connect_slot_signals()


func _connect_slot_signals() -> void:
	pass


func _set_num_slots() -> void:
	num_slots = num_job_slots
