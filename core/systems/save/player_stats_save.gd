class_name PlayerStatsSaveParticipant
extends SaveParticipant

const IDENTIFIER := "player_stats"

var _player_stats: PlayerStatTracker


func _init(player_stats: PlayerStatTracker) -> void:
	_player_stats = player_stats


func get_save_id() -> String:
	return IDENTIFIER


func on_save_game(saved_data_array: Array[SavedData]) -> void:
	var entry := SavedData.new()
	entry.identifier = IDENTIFIER
	entry.payload = {
		"mantissa": _player_stats.power.mantissa,
		"exponent": _player_stats.power.exponent,
	}
	saved_data_array.append(entry)


func on_load_game(saved_data_array: Array[SavedData]) -> void:
	for data in saved_data_array:
		if data.identifier != IDENTIFIER:
			continue
		_player_stats.power.mantissa = data.payload.get("mantissa", 1.0)
		_player_stats.power.exponent = data.payload.get("exponent", 0)
		return
