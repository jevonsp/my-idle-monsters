class_name Job
extends Resource

@export var name := ""
@export var number_slots := 1
@export var number_seconds := 10
@export var rate_per_second := .5


func _calc_completion_bonus() -> BigNumber:
	var bn := BigNumber.new()
	bn.mantissa = (number_slots * number_seconds * rate_per_second)
	bn.exponent = 10
	return bn
