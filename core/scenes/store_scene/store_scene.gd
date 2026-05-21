class_name StoreScene
extends Scene


func request_scene_layout() -> void:
	EventBus.request_layout.emit(PlayerInvCanvasLayer.Layout.STORE)
