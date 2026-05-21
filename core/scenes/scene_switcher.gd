extends VBoxContainer


func _on_store_pressed() -> void:
	EventBus.screen_manager_toggle.emit(Global.game.store_scene, true)


func _on_job_pressed() -> void:
	EventBus.screen_manager_toggle.emit(Global.game.job_scene, true)


func _on_fight_pressed() -> void:
	EventBus.screen_manager_toggle.emit(Global.game.fight_scene, true)
