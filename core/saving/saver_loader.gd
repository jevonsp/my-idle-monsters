class_name SaverLoader
extends Resource

const DEFAULT_SAVE_PATH := "user://savegame.tres"

@export var save_path: String = DEFAULT_SAVE_PATH

var _participants: Array[Object] = []


func register_participant(obj: Object) -> void:
	if obj == null or not is_instance_valid(obj):
		return
	if obj in _participants:
		return
	_participants.append(obj)


func unregister_participant(obj: Object) -> void:
	_participants.erase(obj)


func save_game() -> Error:
	var saved := SavedGame.new()
	var collected: Array[SavedData] = []
	_call_participants_save(collected)
	saved.saved_data_array = collected
	return ResourceSaver.save(saved, save_path)


func load_game() -> Error:
	if not FileAccess.file_exists(save_path):
		return ERR_FILE_NOT_FOUND
	var loaded := ResourceLoader.load(save_path)
	if loaded == null:
		return ERR_INVALID_DATA
	if not loaded is SavedGame:
		return ERR_INVALID_DATA
	var saved := loaded as SavedGame
	_call_participants_before_load()
	_call_participants_load(saved.saved_data_array)
	return OK


func erase_saved_game() -> bool:
	if not FileAccess.file_exists(save_path):
		return false
	var abs_path := ProjectSettings.globalize_path(save_path)
	return DirAccess.remove_absolute(abs_path) == OK


func save_game_exists() -> bool:
	return FileAccess.file_exists(save_path)


func _call_participants_save(out_array: Array[SavedData]) -> void:
	for p in _participants:
		if p == null or not is_instance_valid(p):
			continue
		if p.has_method("on_save_game"):
			p.call("on_save_game", out_array)


func _call_participants_before_load() -> void:
	for p in _participants:
		if p == null or not is_instance_valid(p):
			continue
		if p.has_method("on_before_load_game"):
			p.call("on_before_load_game")


func _call_participants_load(data: Array[SavedData]) -> void:
	for p in _participants:
		if p == null or not is_instance_valid(p):
			continue
		if p.has_method("on_load_game"):
			p.call("on_load_game", data)
