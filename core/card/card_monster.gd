class_name CardMonster
extends BaseCard

@export var base_power_mantissa := 1.0
@export var base_power_exponent := 0
@export var base_wait_time := 10.0

var base_power:
	get:
		var bn := BigNumber.new()
		bn.mantissa = base_power_mantissa
		bn.exponent = base_power_exponent
		return bn
var wait_timer := 0.0

var is_ready: bool:
	get:
		return wait_timer >= base_wait_time


func reset_wait_timer() -> void:
	wait_timer = 0.0


func on_placed_on_hotbar() -> void:
	reset_wait_timer()


func on_removed_from_hotbar() -> void:
	reset_wait_timer()


func on_wait_timer_finished() -> void:
	var power = base_power
	Global.currency.earn(power)
	reset_wait_timer()
