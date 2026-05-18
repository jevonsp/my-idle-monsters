class_name MainButton
extends Button


func _on_pressed() -> void:
	Global.game.grant_click_reward()
