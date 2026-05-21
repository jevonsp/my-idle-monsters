class_name StoreScene
extends Scene


func set_scene_layout() -> void:
	print("set store layout")
	EventBus.request_layout.emit(
		Global.game.player_inv,
		Control.LayoutPreset.PRESET_CENTER_LEFT,
		300,
		true,
	)
