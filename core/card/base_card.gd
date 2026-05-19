class_name BaseCard
extends Resource

enum CardType { MONSTER, ITEM, GEAR }

@export var name := ""
@export var texture: Texture2D
@export var base_price_mantissa := 1.0
@export var base_price_exponent := 1

var base_price:
	get:
		var bn := BigNumber.new()
		bn.mantissa = base_price_mantissa
		bn.exponent = base_price_exponent
		return bn
