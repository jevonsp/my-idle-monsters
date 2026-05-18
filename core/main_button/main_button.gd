class_name MainButton
extends Button


func _ready() -> void:
	Global.main_button = self
	Global.player_stats.connect_signals()
