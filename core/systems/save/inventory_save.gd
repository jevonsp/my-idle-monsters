class_name InventorySaveParticipant
extends SaveParticipant

const ID_HOTBAR := "hotbar"
const ID_PLAYER_INV := "player_inv"


func on_save_game(saved_data_array: Array[SavedData]) -> void:
	if Global.game.hot_bar:
		var hotbar_entry := SavedData.new()
		hotbar_entry.identifier = ID_HOTBAR
		hotbar_entry.payload = CardSaveUtil.serialize_grid(Global.game.hot_bar)
		saved_data_array.append(hotbar_entry)
	if Global.game.player_inv:
		var inv_entry := SavedData.new()
		inv_entry.identifier = ID_PLAYER_INV
		inv_entry.payload = CardSaveUtil.serialize_grid(Global.game.player_inv)
		saved_data_array.append(inv_entry)


func on_load_game(saved_data_array: Array[SavedData]) -> void:
	for data in saved_data_array:
		if data.identifier == ID_HOTBAR and Global.game.hot_bar:
			CardSaveUtil.apply_grid_payload(Global.game.hot_bar, data.payload)
		elif data.identifier == ID_PLAYER_INV and Global.game.player_inv:
			CardSaveUtil.apply_grid_payload(Global.game.player_inv, data.payload)
