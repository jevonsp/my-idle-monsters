class_name Preferences
extends SaveParticipant

enum FormattingType { SCIENTIFIC, M_SYMBOL, M_NAME, AA }

const IDENTIFIER := "preferences"

var preferred_formatting: FormattingType = FormattingType.SCIENTIFIC


func get_save_id() -> String:
	return IDENTIFIER


func on_save_game(saved_data_array: Array[SavedData]) -> void:
	var entry := SavedData.new()
	entry.identifier = IDENTIFIER
	entry.payload = { "preferred_formatting": preferred_formatting }
	saved_data_array.append(entry)


func on_load_game(saved_data_array: Array[SavedData]) -> void:
	for data in saved_data_array:
		if data.identifier == IDENTIFIER:
			preferred_formatting = data.payload.get(
				"preferred_formatting",
				FormattingType.SCIENTIFIC,
			)
