class_name CurrencySaveParticipant
extends SaveParticipant

const IDENTIFIER := "currency"

var _currency: CurrencyTracker


func _init(currency: CurrencyTracker) -> void:
	_currency = currency


func get_save_id() -> String:
	return IDENTIFIER


func on_save_game(saved_data_array: Array[SavedData]) -> void:
	var entry := SavedData.new()
	entry.identifier = IDENTIFIER
	entry.payload = {
		"mantissa": _currency.money.mantissa,
		"exponent": _currency.money.exponent,
	}
	saved_data_array.append(entry)


func on_load_game(saved_data_array: Array[SavedData]) -> void:
	for data in saved_data_array:
		if data.identifier != IDENTIFIER:
			continue
		_currency.load_from_save(
			data.payload.get("mantissa", 0.0),
			data.payload.get("exponent", 0),
		)
		return
