class_name SaveParticipant
extends RefCounted

## Implement save hooks on subclasses. Register instances only via Global._register_saves().


func get_save_id() -> String:
	return ""


func on_save_game(_out: Array[SavedData]) -> void:
	pass


func on_before_load_game() -> void:
	pass


func on_load_game(_data: Array[SavedData]) -> void:
	pass
