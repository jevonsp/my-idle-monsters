class_name CardSaveUtil
extends RefCounted


static func serialize_card(card: BaseCard) -> Dictionary:
	var data := {
		"script": card.get_script().resource_path,
		"card_type": card.card_type,
		"name": card.name,
		"base_price_mantissa": card.base_price_mantissa,
		"base_price_exponent": card.base_price_exponent,
	}
	if card.texture:
		data["texture"] = card.texture.resource_path
	if card is CardMonster:
		var monster := card as CardMonster
		data["base_power_mantissa"] = monster.base_power_mantissa
		data["base_power_exponent"] = monster.base_power_exponent
		data["base_wait_time"] = monster.base_wait_time
		data["wait_timer"] = monster.wait_timer
	return data


static func deserialize_card(data: Dictionary) -> BaseCard:
	var script_path: String = data.get("script", "")
	if script_path.is_empty():
		return null
	var script := load(script_path) as GDScript
	if script == null:
		return null
	var card: BaseCard = script.new()
	card.card_type = data.get("card_type", BaseCard.CardType.MONSTER)
	card.name = data.get("name", "")
	card.base_price_mantissa = data.get("base_price_mantissa", 1.0)
	card.base_price_exponent = data.get("base_price_exponent", 1)
	if data.has("texture"):
		var tex := load(data["texture"]) as Texture2D
		if tex:
			card.texture = tex
	if card is CardMonster:
		var monster := card as CardMonster
		monster.base_power_mantissa = data.get("base_power_mantissa", 1.0)
		monster.base_power_exponent = data.get("base_power_exponent", 0)
		monster.base_wait_time = data.get("base_wait_time", 10.0)
		monster.wait_timer = data.get("wait_timer", 0.0)
	return card


static func serialize_grid(grid: InvGrid) -> Dictionary:
	var slots: Dictionary = {}
	for i in grid.slot_list.size():
		var slot: InvSlot = grid.slot_list[i]
		if slot.inv_card and slot.inv_card.card:
			slots[i] = serialize_card(slot.inv_card.card)
	return { "slots": slots }


static func apply_grid_payload(grid: InvGrid, payload: Dictionary) -> void:
	var slots: Dictionary = payload.get("slots", {})
	for i in grid.slot_list.size():
		grid.slot_list[i].set_item(null)
	for key in slots.keys():
		var index: int = int(key)
		if index < 0 or index >= grid.slot_list.size():
			continue
		var card := deserialize_card(slots[key])
		if card == null:
			continue
		var inv := InvCard.new()
		inv.card = card
		grid.slot_list[index].set_item(inv)
