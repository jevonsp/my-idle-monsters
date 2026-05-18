class_name ClickTracker
extends RefCounted

var cps_array: Array[int] = [0, 0, 0, 0, 0]
var second_timer := 0.0


func connect_signals() -> void:
	if not EventBus.time_ticked.is_connected(_on_time_ticked):
		EventBus.time_ticked.connect(_on_time_ticked)


func register_click() -> void:
	cps_array[0] += 1


func prune_cps_array() -> void:
	cps_array.pop_back()
	cps_array.push_front(0)


func get_raw_cps() -> float:
	var res := 0.0
	for i in cps_array.size():
		res += cps_array[i]
	res /= cps_array.size()
	return res


func _on_time_ticked(delta: float) -> void:
	second_timer += delta
	if second_timer >= 1.0:
		prune_cps_array()
		second_timer = 0.0
