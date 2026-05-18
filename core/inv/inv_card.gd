class_name InvCard
extends Resource

enum ItemType { MONSTER, ITEM, GEAR }

@export var name := ""
@export var item_type := ItemType.MONSTER
@export var texture: Texture2D
@export var mantissa := 1.0
@export var expontent := 1

var base_price:
	get:
		var bn := BigNumber.new()
		bn.mantissa = mantissa
		bn.exponent = expontent
		return bn
